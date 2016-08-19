class fuel_plugin_mistral_tasks::engine {

  notice('MODULAR: fuel_plugin_mistral_tasks/engine.pp')

  include fuel_plugin_mistral_tasks

  class { '::mistral::engine': }

}
