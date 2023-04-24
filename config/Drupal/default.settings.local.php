<?php

// Copy this file and name it settings.local.php for your local overrides.
// The file 'settings.local.php' should not be committed to the git repo

$databases['default']['default'] = array (
  'database' => getenv("MARIADB_DATABASE"),
  'username' => getenv("MARIADB_USER"),
  'password' => getenv("MARIADB_PASSWORD"),
  'prefix' => '',
  'host' => getenv("MARIADB_HOST"),
  'port' => getenv("MARIADB_PORT"),
  'namespace' => 'Drupal\\mysql\\Driver\\Database\\mysql',
  'driver' => 'mysql',
  'autoload' => 'core/modules/mysql/src/Driver/Database/mysql/',
);
$settings['hash_salt'] = 'e7OpC1vzaHT10Pa-N_Qu-AWJ_taeoro3T25ZfE1ddZh7RnB6roQkc_jAQx6PdoV_HbssnmVEYA';

//$config['environment_indicator.indicator']['name'] = 'Live Local';
//$config['environment_indicator.indicator']['bg_color'] = '#500000';
//$config['environment_indicator.indicator']['fg_color'] = '#ffffff';

// Set to true when working in local.
// Be sure to flush cache and import config after changing the value.
//$config['config_split.config_split.local']['status'] = true;
//$config['config_split.config_split.dev']['status'] = true;
//$config['config_split.config_split.test']['status'] = true;

$config['system.performance']['cache']['page']['use_internal'] = TRUE;
$config['system.performance']['css']['preprocess'] = TRUE;
$config['system.performance']['css']['gzip'] = TRUE;
$config['system.perfofrmance']['js']['preprocess'] = FALSE;
$config['system.performance']['js']['gzip'] = TRUE;
$config['system.performance']['response']['gzip'] = FALSE;
$config['views.settings']['ui']['show']['sql_query']['enabled'] = FALSE;
$config['views.settings']['ui']['show']['performance_statistics'] = FALSE;
$config['system.logging']['error_level'] = 'none';