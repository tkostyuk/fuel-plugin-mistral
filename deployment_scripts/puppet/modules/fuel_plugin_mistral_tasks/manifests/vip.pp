class fuel_plugin_mistral_tasks::vip {

  notice('MODULAR: fuel_plugin_mistral_tasks/api_ha.pp')

  include fuel_plugin_mistral_tasks

  # variables to be moved to fuel_plugin_mistral_tasks/manifests/init.pp

  openstack::ha::haproxy_service { 'mistral-api':
    internal_virtual_ip    => $fuel_plugin_mistral_tasks::internal_virtual_ip,
    listen_port            => $fuel_plugin_mistral_tasks::port,
    order                  => '300',
    public_virtual_ip      => $fuel_plugin_mistral_tasks::public_virtual_ip,
    internal               => true,
    public                 => true,
    ipaddresses            => $fuel_plugin_mistral_tasks::mistral_api_nodes_ips,
    server_names           => $fuel_plugin_mistral_tasks::mistral_api_nodes_ips,
    public_ssl             => $fuel_plugin_mistral_tasks::public_ssl,
    public_ssl_path        => $fuel_plugin_mistral_tasks::public_ssl_path,
    haproxy_config_options => {
        option         => ['httpchk', 'httplog', 'httpclose'],
        'http-request' => 'set-header X-Forwarded-Proto https if { ssl_fc }',
    },
    balancermember_options => 'check inter 10s fastinter 2s downinter 3s rise 3 fall 3',
  }

  firewall { '300 mistral':
    chain  => 'INPUT',
    dport  => $fuel_plugin_mistral_tasks::port,
    proto  => 'tcp',
    action => 'accept',
  }

}
