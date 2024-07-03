#!/usr/bin/env bash

set -o errexit
set -o pipefail
set -o nounset

if [[ -n "${DEBUG}" ]]; then
    set -o xtrace
fi

# Exit cleanly if the "DRUPAL_DEPLOY_CHANGES" env var is not set to "auto".
if [[ "${DRUPAL_DEPLOY_CHANGES:}" != "auto" ]]; then
  echo "Skipping automatic drupal deploy."
  exit 0
else
  echo "Starting automatic drupal deploy."
fi

drsh() {
  drush --root="${DRUPAL_ROOT}" --uri="${PROJECT_BASE_URL:-}" ${@}
}

run_query() {
  $(drsh sql:connect) -s -N -e "${1}"
}

get_db_version() {
  local drupal_db_version_key_name="db-schema-version"

  echo $(run_query "SELECT value FROM key_value WHERE collection='frontkom' AND name='${drupal_db_version_key_name}'")
}

main() {
  deployment_identifier_file="${APP_ROOT}/.VERSION"

  # Set CWD to App Root.
  cd "${APP_ROOT}" || (echo "Cannot cd into app root: ${APP_ROOT}" >&2 ; exit)

  # Check if the DB is even populated with a basic table.
  if [[ "$(run_query "SHOW TABLES LIKE 'key_value';" | wc -l)" -eq 0 ]]; then
    echo "Quitting: Database not installed."
    exit 0
  fi

  # Ensure the deployment identifier file exists.
  if [[ ! -f "${deployment_identifier_file}" ]]; then
    echo "Quitting: Missing deployment identifier file: ${deployment_identifier_file}" >&2
    exit 0
  fi
  codebase_version="$(<$deployment_identifier_file)"

  if [[ "$(get_db_version)" == "${codebase_version}" ]]; then
    echo "Quitting: Database already at latest version." >&2
    exit 0
  fi

  # Run deploy actions.
  ${DRUPAL_DEPLOY_COMMAND:-"composer deploy"}

  # Update the version identifier in the db.
  upsert_query="INSERT INTO key_value (collection, name, value) \
    VALUES ('nymedia', '${drupal_db_version_key_name}', '${codebase_version}') \
    ON DUPLICATE KEY UPDATE value='${codebase_version}';"

  run_query "${upsert_query}"
}


main $@
