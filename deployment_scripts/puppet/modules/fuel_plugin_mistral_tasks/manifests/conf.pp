class fuel_plugin_mistral_tasks::conf {

  notice('MODULAR: fuel-plugin-mistral/conf.pp')
  $roles = hiera(roles)
  include fuel_plugin_mistral_tasks
  
  Package <| title == 'mistral-common' |> {
    name => 'mistral-common',
  }
  class { '::mistral':
    keystone_password                  => $fuel_plugin_mistral_tasks::mistral_user_password,
    keystone_user                      => $fuel_plugin_mistral_tasks::keystone_user,
    keystone_tenant                    => $fuel_plugin_mistral_tasks::keystone_tenant,
    auth_uri                           => $fuel_plugin_mistral_tasks::auth_uri,
    identity_uri                       => $fuel_plugin_mistral_tasks::identity_uri,
    database_connection                => $fuel_plugin_mistral_tasks::db_connection,
    rpc_backend                        => $fuel_plugin_mistral_tasks::rpc_backend,
    rabbit_hosts                       => $fuel_plugin_mistral_tasks::rabbit_hosts,
    rabbit_userid                      => $fuel_plugin_mistral_tasks::rabbit_hash['user'],
    rabbit_password                    => $fuel_plugin_mistral_tasks::rabbit_hash['password'],
    control_exchange                   => $fuel_plugin_mistral_tasks::control_exchange,
    rabbit_ha_queues                   => $fuel_plugin_mistral_tasks::rabbit_ha_queues,
  }

  mistral_config {
    'keystone_authtoken/auth_version': value => $fuel_plugin_mistral_tasks::auth_version;
  }
  if 'primary-controller' in $roles {
    class {::mistral::db::sync:}
  }
}
