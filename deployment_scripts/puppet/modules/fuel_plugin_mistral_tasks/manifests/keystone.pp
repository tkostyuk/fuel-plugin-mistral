class fuel_plugin_mistral_tasks::keystone {

  notice('MODULAR: fuel-plugin-mistral/keystone.pp')

  include fuel_plugin_mistral_tasks

  Class['::osnailyfacter::wait_for_keystone_backends'] -> Class['::mistral::keystone::auth']

  class { '::osnailyfacter::wait_for_keystone_backends':}
  class { '::mistral::keystone::auth':
    password            => $fuel_plugin_mistral_tasks::password,
    auth_name           => $fuel_plugin_mistral_tasks::auth_name,
    configure_endpoint  => $fuel_plugin_mistral_tasks::configure_endpoint,
    configure_user      => $fuel_plugin_mistral_tasks::configure_user,
    configure_user_role => $fuel_plugin_mistral_tasks::configure_user_role,
    service_name        => $fuel_plugin_mistral_tasks::service_name,
    service_type        => $fuel_plugin_mistral_tasks::service_type,
    public_url          => $fuel_plugin_mistral_tasks::public_url,
    internal_url        => $fuel_plugin_mistral_tasks::internal_url,
    admin_url           => $fuel_plugin_mistral_tasks::admin_url,
    region              => $fuel_plugin_mistral_tasks::region,
    tenant              => $fuel_plugin_mistral_tasks::tenant,
  }

}
