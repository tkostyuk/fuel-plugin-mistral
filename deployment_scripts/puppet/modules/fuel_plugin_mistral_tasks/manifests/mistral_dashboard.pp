class fuel_plugin_mistral_tasks::mistral_dashboard {
  include fuel_plugin_mistral_tasks
  include horizon::params

  package { 'python-pip':
    ensure => installed,
  }

  package { 'mistral-dashboard':
    ensure   => $fuel_plugin_mistral_tasks::mistral_dashboard_version,
    provider => pip,
    require  => Package['python-pip']
  }

  file { $fuel_plugin_mistral_tasks::mistral_horizon_ext_file:
    ensure => file,
    content => template('fuel_plugin_mistral_tasks/_50_mistral.py.erb'),
    owner  => 'root',
    group  => 'root',
    mode   => '0644',
  }

  service { $horizon::params::http_service:
    ensure => running,
  }

  Package['mistral-dashboard'] ->
    File[$fuel_plugin_mistral_tasks::mistral_horizon_ext_file] ~>
      Service[$horizon::params::http_service]
}
