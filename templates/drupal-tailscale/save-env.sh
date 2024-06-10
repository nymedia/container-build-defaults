#!/usr/bin/env bash
#
# This script saves a predefined list of environment variables to a file.
#
# We chose the file "/etc/profile" because it is sourced by the shell on login.
#
##########
# Why do we need to save the environment variables, you might ask?
##########
# Because of a bug/limitation in the way Tailscale SSH runs commands:
# https://github.com/tailscale/tailscale/issues/12395
#
# Until the bug is fixed, we need to save the environment variables to a file
# so that they are available when the shell is started by Tailscale SSH.
#
##########

if [ "${DEBUG:-no}" != "no" ]; then
  set -x
fi

set -o errexit
set -o nounset
set -o pipefail

# This file will be sourced by the shell on login
DEST_FILE="${HOME}/.shrc"

# Define a list of environment variables that should be excluded.
# These are the environment variables that are set by the shell itself and
# should not be saved to the file to avoid conflicts.
declare -a exclude_vars=(
  "CHARSET"
  "COLUMNS"
  "ENV"
  "GPG_KEYS"
  "HOME"
  "HOSTNAME"
  "LANG"
  "LC_ADDRESS"
  "LC_COLLATE"
  "LC_IDENTIFICATION"
  "LC_MEASUREMENT"
  "LC_MONETARY"
  "LC_NAME"
  "LC_NUMERIC"
  "LC_PAPER"
  "LC_TELEPHONE"
  "LC_TIME"
  "PAGER"
  "PATH"
  "PS1"
  "PWD"
  "ROWS"
  "SHELL"
  "SHLVL"
  "SSH_CLIENT"
  "SSH_CONNECTION"
  "SSH_TTY"
  "TERM"
  "TS_AUTH_ONCE"
  "TS_AUTHKEY"
  "TS_EXTRA_ARGS"
  "TS_HOSTNAME"
  "TS_SOCKET"
  "TS_STATE_DIR"
  "TS_USERSPACE"
  "USER"
)

for var_name in $(printenv | cut -d= -f1); do
  if [[ ! " ${exclude_vars[@]} " =~ " ${var_name} " ]]; then
    var_names+=("${var_name}")
  fi
done

# Save the environment variables to the file
echo "The following environment variables will be saved to ${DEST_FILE}:"
echo "${var_names[@]}"

for var_name in "${var_names[@]}"; do
  echo "export ${var_name}='$(printenv "${var_name}")'" >> "${DEST_FILE}"
done

# Ensure that the environment variables are loaded by any shell:
# https://github.com/wodby/php/blob/24c9b29ab5e32328173fd23124d09a2d80baca5b/8/Dockerfile#L334-L335
cp "${HOME}/.shrc" "${HOME}/.bashrc"
cp "${HOME}/.shrc" "${HOME}/.bash_profile"
