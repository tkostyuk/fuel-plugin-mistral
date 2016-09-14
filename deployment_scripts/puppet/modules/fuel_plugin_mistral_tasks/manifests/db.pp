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

class fuel_plugin_mistral_tasks::db {

  notice('MODULAR: fuel-plugin-mistral/db.pp')

  include fuel_plugin_mistral_tasks

  if $fuel_plugin_mistral_tasks::db_create {

    class { '::openstack::galera::client':
      custom_setup_class => hiera('mysql_custom_setup_class', 'galera'),
    }

    class { '::mistral::db::mysql':
      user          => $fuel_plugin_mistral_tasks::db_user,
      password      => $fuel_plugin_mistral_tasks::db_password,
      dbname        => $fuel_plugin_mistral_tasks::db_name,
      allowed_hosts => $fuel_plugin_mistral_tasks::allowed_hosts,
    }

    class { '::osnailyfacter::mysql_access':
      db_host     => $fuel_plugin_mistral_tasks::db_host,
      db_user     => $fuel_plugin_mistral_tasks::db_root_user,
      db_password => $fuel_plugin_mistral_tasks::db_root_password,
    }

    Class['::openstack::galera::client'] ->
      Class['::osnailyfacter::mysql_access'] ->
        Class['::mistral::db::mysql']

  }

}
