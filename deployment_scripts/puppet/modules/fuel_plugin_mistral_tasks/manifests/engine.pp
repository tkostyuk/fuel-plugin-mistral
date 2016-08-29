class fuel_plugin_mistral_tasks::engine {

  notice('MODULAR: fuel_plugin_mistral_tasks/engine.pp')

  include fuel_plugin_mistral_tasks

  class { '::mistral::engine': }

  Mistral_config <||> ~> Service[$::mistral::params::engine_service_name]
  Package['mistral-engine'] -> Service[$::mistral::params::engine_service_name]
  Package['mistral-engine'] -> Service['mistral-engine']
}
