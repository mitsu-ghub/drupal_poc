<?php

/**
 * Load services definition file.
 */
$settings['container_yamls'][] = __DIR__ . '/services.yml';

/**
 * Include the Pantheon-specific settings file.
 *
 * n.b. The settings.pantheon.php file makes some changes
 *      that affect all environments that this site
 *      exists in.  Always include this file, even in
 *      a local development environment, to ensure that
 *      the site settings remain consistent.
 */
include __DIR__ . "/settings.pantheon.php";

/**
 * Skipping permissions hardening will make scaffolding
 * work better, but will also raise a warning when you
 * install Drupal.
 *
 * https://www.drupal.org/project/drupal/issues/3091285
 */
// $settings['skip_permissions_hardening'] = TRUE;

$settings['config_sync_directory'] = dirname(DRUPAL_ROOT) . '/config';
$settings['config_exclude_modules'] = [
  'devel',
];

/**
 * If there is a local settings file, then include it
 */
$local_settings = __DIR__ . "/settings.local.php";
if (file_exists($local_settings)) {
  include $local_settings;
}
/*
$settings['trusted_host_patterns'] = [
  '^live-techmahindra2\.pantheonsite\.io$',
  '^test-techmahindra2\.pantheonsite\.io$',
  '^dev-techmahindra2\.pantheonsite\.io$',
  '^www\.techmahindra\.com$',
  '^techmahindra\.com$',
  '^live\.techm\.com$',
  '^dev\.techm\.com$',
  '^local\.techm\.com$',
  '^localhost$',
];
*/

// Configure Redis

if (defined('PANTHEON_ENVIRONMENT')) {
  // Include the Redis services.yml file. Adjust the path if you installed to a contrib or other subdirectory.
  $settings['container_yamls'][] = 'modules/redis/example.services.yml';

  //phpredis is built into the Pantheon application container.
  $settings['redis.connection']['interface'] = 'PhpRedis';
  // These are dynamic variables handled by Pantheon.
  $settings['redis.connection']['host']      = $_ENV['CACHE_HOST'];
  $settings['redis.connection']['port']      = $_ENV['CACHE_PORT'];
  $settings['redis.connection']['password']  = $_ENV['CACHE_PASSWORD'];

  $settings['redis_compress_length'] = 100;
  $settings['redis_compress_level'] = 1;

  $settings['cache']['default'] = 'cache.backend.redis'; // Use Redis as the default cache.
  $settings['cache_prefix']['default'] = 'pantheon-redis';

  $settings['cache']['bins']['form'] = 'cache.backend.database'; // Use the database for forms
}

if (isset($_ENV['PANTHEON_ENVIRONMENT'])) {
   switch($_ENV['PANTHEON_ENVIRONMENT']) {
    case 'dev':
        $config['config_split.config_split.dev']['status'] = true;
        $config['system.performance']['cache']['page']['use_internal'] = FALSE;
        $config['system.performance']['css']['preprocess'] = FALSE;
        $config['system.performance']['css']['gzip'] = FALSE;
        $config['system.performance']['js']['preprocess'] = FALSE;
        $config['system.performance']['js']['gzip'] = FALSE;
        $config['system.performance']['response']['gzip'] = FALSE;
        $config['views.settings']['ui']['show']['sql_query']['enabled'] = TRUE;
        $config['views.settings']['ui']['show']['performance_statistics'] = TRUE;
        $config['system.logging']['error_level'] = 'all';
        # $settings['cache']['bins']['render'] = 'cache.backend.null';
        # $settings['cache']['bins']['dynamic_page_cache'] = 'cache.backend.null';
    break;
    case 'test':
        $config['config_split.config_split.test']['status'] = true;
        $config['system.performance']['cache']['page']['use_internal'] = TRUE;
        $config['system.performance']['css']['preprocess'] = TRUE;
        $config['system.performance']['css']['gzip'] = TRUE;
        $config['system.performance']['js']['preprocess'] = TRUE;
        $config['system.performance']['js']['gzip'] = TRUE;
        $config['system.performance']['response']['gzip'] = TRUE;
        $config['views.settings']['ui']['show']['sql_query']['enabled'] = FALSE;
        $config['views.settings']['ui']['show']['performance_statistics'] = FALSE;
        $config['system.logging']['error_level'] = 'none';
    break;
    case 'live':
        $config['config_split.config_split.dev']['status'] = false;
        $config['config_split.config_split.test']['status'] = false;
        $config['system.performance']['cache']['page']['use_internal'] = TRUE;
        $config['system.performance']['css']['preprocess'] = TRUE;
        $config['system.performance']['css']['gzip'] = TRUE;
        $config['system.performance']['js']['preprocess'] = TRUE;
        $config['system.performance']['js']['gzip'] = TRUE;
        $config['system.performance']['response']['gzip'] = TRUE;
        $config['views.settings']['ui']['show']['sql_query']['enabled'] = FALSE;
        $config['views.settings']['ui']['show']['performance_statistics'] = FALSE;
        $config['system.logging']['error_level'] = 'none';
    break;
    }
}