class fuel_plugin_mistral_tasks::api {

  notice('MODULAR: fuel_plugin_mistral_tasks/api.pp')

  include fuel_plugin_mistral_tasks

  class { '::mistral::api': }

}
