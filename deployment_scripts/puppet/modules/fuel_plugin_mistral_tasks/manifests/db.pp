class fuel_plugin_mistral_tasks::db {

  notice('MODULAR: fuel_plugin_mistral_tasks/db.pp')

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
