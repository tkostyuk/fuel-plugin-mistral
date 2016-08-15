class openstack_tasks::mistral::keystone {

  notice('MODULAR: mistral/keystone.pp')

  $mistral_hash        = hiera_hash('fuel-plugin-mistral', {})
  $public_ssl_hash     = hiera_hash('public_ssl')
  $ssl_hash            = hiera_hash('use_ssl', {})
  $public_vip          = hiera('public_vip')
  $management_vip      = hiera('management_vip')

  Class['::osnailyfacter::wait_for_keystone_backends'] -> Class['::mistral::keystone::auth']

  $public_protocol     = get_ssl_property($ssl_hash, $public_ssl_hash, 'mistral', 'public', 'protocol', 'http')
  $public_address      = get_ssl_property($ssl_hash, $public_ssl_hash, 'mistral', 'public', 'hostname', [$public_vip])

  $internal_protocol   = get_ssl_property($ssl_hash, {}, 'mistral', 'internal', 'protocol', 'http')
  $internal_address    = get_ssl_property($ssl_hash, {}, 'mistral', 'internal', 'hostname', [$management_vip])

  $admin_protocol      = get_ssl_property($ssl_hash, {}, 'mistral', 'admin', 'protocol', 'http')
  $admin_address       = get_ssl_property($ssl_hash, {}, 'mistral', 'admin', 'hostname', [$management_vip])

  $port = '8989'

  $public_base_url     = "${public_protocol}://${public_address}:${port}"
  $internal_base_url   = "${internal_protocol}://${internal_address}:${port}"
  $admin_base_url      = "${admin_protocol}://${admin_address}:${port}"

  $region              = pick($mistral_hash['region'], hiera('region', 'RegionOne'))
  $password            = $mistral_hash['user_password']
  $auth_name           = pick($mistral_hash['auth_name'], 'mistral')
  $configure_endpoint  = pick($mistral_hash['configure_endpoint'], true)
  $configure_user      = pick($mistral_hash['configure_user'], true)
  $configure_user_role = pick($mistral_hash['configure_user_role'], true)
  $service_name        = pick($mistral_hash['service_name'], 'mistral')
  $service_type        = pick($mistral_hash['service_type'], 'workflow')
  $tenant              = pick($mistral_hash['tenant'], 'services')

  validate_string($public_address)
  validate_string($internal_address)
  validate_string($admin_address)
  validate_string($password)

  class { '::osnailyfacter::wait_for_keystone_backends':}
  class { '::mistral::keystone::auth':
    password            => $password,
    auth_name           => $auth_name,
    configure_endpoint  => $configure_endpoint,
    configure_user      => $configure_user,
    configure_user_role => $configure_user_role,
    service_name        => $service_name,
    service_type        => $service_type,
    public_url          => "${public_base_url}/v2",
    internal_url        => "${internal_base_url}/v2",
    admin_url           => "${admin_base_url}/v2",
    region              => $region,
    tenant              => $tenant,
  }

}
