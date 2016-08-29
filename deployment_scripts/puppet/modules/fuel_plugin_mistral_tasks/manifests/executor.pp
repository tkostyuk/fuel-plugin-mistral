class fuel_plugin_mistral_tasks::executor {

  notice('MODULAR: fuel_plugin_mistral_tasks/executor.pp')

  include fuel_plugin_mistral_tasks

  class { '::mistral::executor': }
  Mistral_config <||> ~> Service[$::mistral::params::executor_service_name]
  Package['mistral-executor'] -> Service[$::mistral::params::executor_service_name]
  Package['mistral-executor'] -> Service['mistral-executor']

}
