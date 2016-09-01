class fuel_plugin_mistral_tasks {

  $mistral_hash           = hiera_hash('fuel-plugin-mistral', {})
  $mysql_hash             = hiera_hash('mysql', {})
  $management_vip         = hiera('management_vip', undef)
  $database_vip           = hiera('database_vip', undef)

  $mysql_root_user        = pick($mysql_hash['root_user'], 'root')
  $mysql_db_create        = pick($mysql_hash['db_create'], true)
  $mysql_root_password    = $mysql_hash['root_password']

  $db_user                = pick($mistral_hash['db_user'], 'mistral')
  $db_name                = pick($mistral_hash['db_name'], 'mistral')
  $db_password            = pick($mistral_hash['db_password'], $mysql_root_password)

  $db_host                = pick($mistral_hash['db_host'], $database_vip)
  $db_create              = pick($mistral_hash['db_create'], $mysql_db_create)
  $db_root_user           = pick($mistral_hash['root_user'], $mysql_root_user)
  $db_root_password       = pick($mistral_hash['root_password'], $mysql_root_password)

  $allowed_hosts          = [ 'localhost', '127.0.0.1', '%' ]

  validate_string($fuel_plugin_mistral_tasks::mysql_root_user)






  $rabbit_hash            = hiera_hash('rabbit', {})

  $rabbit_hosts           = split(hiera('amqp_hosts',''), ',')
  $control_exchange       = 'mistral'
  $rabbit_ha_queues       = true


  $public_ssl_hash        = hiera_hash('public_ssl')
  $ssl_hash               = hiera_hash('use_ssl', {})
  $public_vip             = hiera('public_vip')
  $service_endpoint       = hiera('service_endpoint')

  $mistral_user_password  = $mistral_hash['user_password']
  $keystone_user          = pick($mistral_hash['auth_name'], 'mistral')
  $keystone_tenant        = pick($mistral_hash['tenant'], 'services')

  $keystone_auth_protocol = get_ssl_property($ssl_hash, {}, 'keystone', 'internal', 'protocol', 'http')
  $keystone_auth_host     = get_ssl_property($ssl_hash, {}, 'keystone', 'internal', 'hostname', [hiera('keystone_endpoint', ''), $service_endpoint, $management_vip])

  $service_port           = '5000'
  $auth_version           = 'v3'
  $auth_uri               = "${keystone_auth_protocol}://${keystone_auth_host}:${service_port}/${$auth_version}"
  $identity_uri           = "${keystone_auth_protocol}://${keystone_auth_host}:${service_port}/"

  $db_type                = 'mysql'

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







  $public_protocol        = get_ssl_property($ssl_hash, $public_ssl_hash, 'mistral', 'public', 'protocol', 'http')
  $public_address         = get_ssl_property($ssl_hash, $public_ssl_hash, 'mistral', 'public', 'hostname', [$public_vip])

  $internal_protocol      = get_ssl_property($ssl_hash, {}, 'mistral', 'internal', 'protocol', 'http')
  $internal_address       = get_ssl_property($ssl_hash, {}, 'mistral', 'internal', 'hostname', [$management_vip])

  $admin_protocol         = get_ssl_property($ssl_hash, {}, 'mistral', 'admin', 'protocol', 'http')
  $admin_address          = get_ssl_property($ssl_hash, {}, 'mistral', 'admin', 'hostname', [$management_vip])

  $port = '8989'

  $public_base_url        = "${public_protocol}://${public_address}:${port}"
  $internal_base_url      = "${internal_protocol}://${internal_address}:${port}"
  $admin_base_url         = "${admin_protocol}://${admin_address}:${port}"

  $public_url             = "${public_base_url}/v2"
  $internal_url           = "${internal_base_url}/v2"
  $admin_url              = "${admin_base_url}/v2"

  $region                 = pick($mistral_hash['region'], hiera('region', 'RegionOne'))
  $password               = $mistral_hash['user_password']
  $auth_name              = pick($mistral_hash['auth_name'], 'mistral')
  $configure_endpoint     = pick($mistral_hash['configure_endpoint'], true)
  $configure_user         = pick($mistral_hash['configure_user'], true)
  $configure_user_role    = pick($mistral_hash['configure_user_role'], true)
  $service_name           = pick($mistral_hash['service_name'], 'mistral')
  $service_type           = pick($mistral_hash['service_type'], 'workflowv2')
  $tenant                 = pick($mistral_hash['tenant'], 'services')


  validate_string($public_address)
  validate_string($internal_address)
  validate_string($admin_address)
  validate_string($password)

  # VIP part

  $network_metadata = hiera_hash('network_metadata', {})

  # Mistral API runs on Controllers
  $mistral_api_nodes_hash         = get_nodes_hash_by_roles($network_metadata, ['primary-controller','controller'])
  $mistral_api_nodes_ips          = ipsort(values(get_node_to_ipaddr_map_by_network_role($mistral_api_nodes_hash, 'management')))

  $public_virtual_ip   = hiera('public_vip')
  $internal_virtual_ip = hiera('management_vip')

  $public_ssl         = get_ssl_property($ssl_hash, $public_ssl_hash, 'mistral', 'public', 'usage', false)
  $public_ssl_path    = get_ssl_property($ssl_hash, $public_ssl_hash, 'mistral', 'public', 'path', [''])
  $internal_ssl       = get_ssl_property($ssl_hash, {}, 'cinder', 'internal', 'usage', false)
  $internal_ssl_path  = get_ssl_property($ssl_hash, {}, 'cinder', 'internal', 'path', [''])

  # API part

  prepare_network_config(hiera_hash('network_scheme', {}))

  $bind_host          = get_network_role_property('management', 'ipaddr')
  $mistral_horizon_ext_file =  '/usr/share/openstack-dashboard/openstack_dashboard/local/enabled/_50_mistral.py'
  $mistral_dashboard_version = '2.0.0'

}
