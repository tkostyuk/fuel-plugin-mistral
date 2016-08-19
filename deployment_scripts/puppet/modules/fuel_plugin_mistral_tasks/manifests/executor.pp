class fuel_plugin_mistral_tasks::executor {

  notice('MODULAR: fuel_plugin_mistral_tasks/executor.pp')

  include fuel_plugin_mistral_tasks

  class { '::mistral::executor': }

}
