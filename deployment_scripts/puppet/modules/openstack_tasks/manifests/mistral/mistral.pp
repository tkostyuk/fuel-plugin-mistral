class openstack_tasks::mistral::mistral {

  notice('MODULAR: mistral/mistral.pp')

  $mistral_hash        = hiera_hash('fuel-plugin-mistral', {})
  $mysql_hash          = hiera_hash('mysql', {})
  $rabbit_hash         = hiera_hash('rabbit', {})
  $public_ssl_hash     = hiera_hash('public_ssl')
  $ssl_hash            = hiera_hash('use_ssl', {})
  $public_vip          = hiera('public_vip')
  $management_vip      = hiera('management_vip')
  $database_vip        = hiera('database_vip', undef)
  $service_endpoint    = hiera('service_endpoint')

  $mistral_user_password        = $mistral_hash['user_password']
  $keystone_user                = pick($mistral_hash['auth_name'], 'mistral')
  $keystone_tenant              = pick($mistral_hash['tenant'], 'services')

  $keystone_auth_protocol = get_ssl_property($ssl_hash, {}, 'keystone', 'internal', 'protocol', 'http')
  $keystone_auth_host     = get_ssl_property($ssl_hash, {}, 'keystone', 'internal', 'hostname', [hiera('keystone_endpoint', ''), $service_endpoint, $management_vip])

  $service_port        = '5000'
  $auth_version        = 'v3'
  $auth_uri            = "${keystone_auth_protocol}://${keystone_auth_host}:${service_port}/${$auth_version}"
  $identity_uri        = "${keystone_auth_protocol}://${keystone_auth_host}:${service_port}/"

  $mysql_root_password = $mysql_hash['root_password']
  $db_type             = 'mysql'
  $db_user             = pick($mistral_hash['db_user'], 'mistral')
  $db_name             = pick($mistral_hash['db_name'], 'mistral')
  $db_password         = $mistral_hash['db_password']

  # LP#1526938 - python-mysqldb supports this, python-pymysql does not
  if $::os_package_type == 'debian' {
    $extra_params = { 'charset' => 'utf8', 'read_timeout' => 60 }
  } else {
    $extra_params = { 'charset' => 'utf8' }
  }
  $db_connection = os_database_connection({
    'dialect'  => $db_type,
    'host'     => $db_host,
    'database' => $db_name,
    'username' => $db_user,
    'password' => $db_password,
    'extra'    => $extra_params
  })

  $queue_provider = hiera('queue_provider', 'rabbit')
  if $queue_provider == 'rabbitmq'{
    $rpc_backend    = 'rabbit'
  } else {
    $rpc_backend = $queue_provider
  }

  class { '::mistral':
    keystone_password                  => $mistral_user_password,
    keystone_user                      => $keystone_user,
    keystone_tenant                    => $keystone_tenant,
    auth_uri                           => $auth_uri,
    identity_uri                       => $identity_uri,
    database_connection                => $db_connection,
    rpc_backend                        => $rpc_backend,
    rabbit_hosts                       => split(hiera('amqp_hosts',''), ','),
    rabbit_userid                      => $rabbit_hash['user'],
    rabbit_password                    => $rabbit_hash['password'],
    control_exchange                   => 'mistral',
    rabbit_ha_queues                   => true,
  }

  mistral_config {
    'keystone_authtoken/auth_version': value => $auth_version;
  }

}
