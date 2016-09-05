class fuel_plugin_mistral_tasks::api {

  notice('MODULAR: fuel-plugin-mistral/api.pp')

  include fuel_plugin_mistral_tasks

  class { '::mistral::api':
    bind_host => $fuel_plugin_mistral_tasks::bind_host,
  }

}
