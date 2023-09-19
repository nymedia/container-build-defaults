<?php

// Declare the current env type based on the env vars.
$ENV_TYPE = $_SERVER['ENVIRONMENT_TYPE'] ?? 'local';

/*
 *  Load the services definitions depending on the environment.
 */
$settings['container_yamls'][] = "{$app_root}/{$site_path}/services.{$ENV_TYPE}.yml";

/*
 * Include the settings which are shared for all environments.
 */
$settings_file = __DIR__ . '/settings-shared.php';
file_exists($settings_file) && include $settings_file;

/*
 * Next we include two possible overrides based on:
 * - environment type
 * - environment name, when defined.
 *
 * This system allows to extensive overrides while allowing to maintain setting files tracked in the repository.
 */
$settings_file = __DIR__ . "/settings.{$ENV_TYPE}.php";
file_exists($settings_file) && include $settings_file;
if (!empty($_SERVER['ENVIRONMENT_NAME'])) {
  $settings_file = __DIR__ . "/settings.{$_SERVER['ENVIRONMENT_NAME']}.php";
  file_exists($settings_file) && include $settings_file;
}

/**
 * Load environment based override configuration.
 */
if (file_exists($app_root . '/' . $site_path . '/settings.env.php')) {
  include $app_root . '/' . $site_path . '/settings.env.php';
}

/*
 * Lastly when we use containers based on the wodby/drupal-php base image some configuration is auto-generated based on environment variables.
 * This file is generated in $CONF_DIR/wodby.settings.php, so we check if this file exists and in this case we include it to set the defaults.
 */
if (isset($_SERVER['CONF_DIR'])) {
  $settings_file =  "{$_SERVER['CONF_DIR']}/wodby.settings.php";
  file_exists($settings_file) && include $settings_file;
}

/**
 * Ensure location of the site configuration files.
 */
$settings["config_sync_directory"] = dirname(DRUPAL_ROOT) . '/config/common/';
