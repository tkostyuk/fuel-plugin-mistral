class fuel_plugin_mistral_tasks::vip {

  notice('MODULAR: fuel_plugin_mistral_tasks/api_ha.pp')


  # variables to be moved to fuel_plugin_mistral_tasks/manifests/init.pp

  $network_metadata = hiera_hash('network_metadata', {})

  # Mistral API runs on Controllers
  $mistral_api_nodes_hash         = get_nodes_hash_by_roles($network_metadata, ['primary-controller','controller'])
  $mistral_api_nodes_ips          = ipsort(values(get_node_to_ipaddr_map_by_network_role($mistral_api_nodes_hash, 'management')))

  $port = '8989'

  $public_virtual_ip   = hiera('public_vip')
  $internal_virtual_ip = hiera('management_vip')

  $public_ssl_hash    = hiera_hash('public_ssl', {})
  $ssl_hash           = hiera_hash('use_ssl', {})
  $public_ssl         = get_ssl_property($ssl_hash, $public_ssl_hash, 'mistral', 'public', 'usage', false)
  $public_ssl_path    = get_ssl_property($ssl_hash, $public_ssl_hash, 'mistral', 'public', 'path', [''])
  $internal_ssl       = get_ssl_property($ssl_hash, {}, 'cinder', 'internal', 'usage', false)
  $internal_ssl_path  = get_ssl_property($ssl_hash, {}, 'cinder', 'internal', 'path', [''])


  openstack::ha::haproxy_service { 'mistral-api':
    internal_virtual_ip    => $internal_virtual_ip,
    listen_port            => $port,
    order                  => '300',
    public_virtual_ip      => $public_virtual_ip,
    internal               => true,
    public                 => true,
    ipaddresses            => $mistral_api_nodes_ips,
    server_names           => $mistral_api_nodes_ips,
    public_ssl             => $public_ssl,
    public_ssl_path        => $public_ssl_path,
    haproxy_config_options => {
        option         => ['httpchk', 'httplog', 'httpclose'],
        'http-request' => 'set-header X-Forwarded-Proto https if { ssl_fc }',
    },
    balancermember_options => 'check inter 10s fastinter 2s downinter 3s rise 3 fall 3',
  }

}
