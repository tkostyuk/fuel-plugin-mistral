#    Copyright 2016 Mirantis, Inc.
#
#    Licensed under the Apache License, Version 2.0 (the "License"); you may
#    not use this file except in compliance with the License. You may obtain
#    a copy of the License at
#
#         http://www.apache.org/licenses/LICENSE-2.0
#
#    Unless required by applicable law or agreed to in writing, software
#    distributed under the License is distributed on an "AS IS" BASIS, WITHOUT
#    WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the
#    License for the specific language governing permissions and limitations
#    under the License.

class fuel_plugin_mistral_tasks::vip {

  notice('MODULAR: fuel-plugin-mistral/vip.pp')

  include fuel_plugin_mistral_tasks

  # variables to be moved to fuel_plugin_mistral_tasks/manifests/init.pp

  openstack::ha::haproxy_service { 'mistral-api':
    internal_virtual_ip    => $fuel_plugin_mistral_tasks::management_vip,
    listen_port            => $fuel_plugin_mistral_tasks::port,
    order                  => '300',
    public_virtual_ip      => $fuel_plugin_mistral_tasks::public_vip,
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
