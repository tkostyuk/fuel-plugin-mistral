class fuel_plugin_mistral_tasks::db::sync {

  notice('MODULAR: fuel_plugin_mistral_tasks/db/sync.pp')

  include fuel_plugin_mistral_tasks

  Exec <| title == 'mistral-db-sync' |> {
    refreshonly => false,
  }

  Exec <| title == 'mistral-db-populate' |> {
    refreshonly => false,
  }

  include mistral::db::sync

}
