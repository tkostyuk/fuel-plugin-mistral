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
