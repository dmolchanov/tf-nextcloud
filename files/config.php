<?php
$CONFIG = array (
  'passwordsalt' => '/z54fa37jE5yZxKuX06rar4eRypy+7',
  'secret' => '/FSq30kJi6PZGeg74g4rga8L+myv2K61jgqeVxNEKCgZFgsm',
  'trusted_domains' =>
  array (
    0 => 'localhost',
    1 => '*',
  ),
  'overwrite.cli.url' => 'http://localhost',
  'dbtype' => 'mysql',
  'version' => '13.0.2.1',
  'dbname' => 'nextcloud',
  'dbhost' => '${db_address}',
  'dbport' => '${db_port}',
  'dbtableprefix' => 'oc_',
  'dbuser' => '${db_user}',
  'dbpassword' => '${db_password}',
  'installed' => true,
  'instanceid' => 'oc8b4eopbi4l',
  'objectstore' =>
  array (
    'class' => 'OC\\Files\\ObjectStore\\S3',
    'arguments' =>
    array (
      'bucket' => '${s3_bucket}',
      'autocreate' => false,
      'key' => '${aws_access}',
      'secret' => '${aws_secret}',
      'hostname' => '${s3_domain}',
      'port' => 443,
      'use_ssl' => true,
      'region' => '${aws_region}',
      'use_path_style' => false,
    ),
  ),
);
