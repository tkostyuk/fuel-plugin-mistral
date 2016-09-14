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

class fuel_plugin_mistral_tasks::conf {

  notice('MODULAR: fuel-plugin-mistral/conf.pp')
  $roles = hiera(roles)
  include fuel_plugin_mistral_tasks
  
  Package <| title == 'mistral-common' |> {
    name => 'mistral-common',
  }
  class { '::mistral':
    keystone_password                  => $fuel_plugin_mistral_tasks::password,
    keystone_user                      => $fuel_plugin_mistral_tasks::auth_name,
    keystone_tenant                    => $fuel_plugin_mistral_tasks::tenant,
    auth_uri                           => $fuel_plugin_mistral_tasks::auth_uri,
    identity_uri                       => $fuel_plugin_mistral_tasks::identity_uri,
    database_connection                => $fuel_plugin_mistral_tasks::db_connection,
    rpc_backend                        => $fuel_plugin_mistral_tasks::rpc_backend,
    rabbit_hosts                       => $fuel_plugin_mistral_tasks::rabbit_hosts,
    rabbit_userid                      => $fuel_plugin_mistral_tasks::rabbit_hash['user'],
    rabbit_password                    => $fuel_plugin_mistral_tasks::rabbit_hash['password'],
    control_exchange                   => $fuel_plugin_mistral_tasks::control_exchange,
    rabbit_ha_queues                   => $fuel_plugin_mistral_tasks::rabbit_ha_queues,
    use_syslog                         => $fuel_plugin_mistral_tasks::use_syslog,
    use_stderr                         => $fuel_plugin_mistral_tasks::use_stderr,
    log_facility                       => $fuel_plugin_mistral_tasks::log_facility,
    verbose                            => $fuel_plugin_mistral_tasks::verbose,
    debug                              => $fuel_plugin_mistral_tasks::debug,
  }

  mistral_config {
    'keystone_authtoken/auth_version': value => $fuel_plugin_mistral_tasks::auth_version;
  }

}
