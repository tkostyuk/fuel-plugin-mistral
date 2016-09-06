class fuel_plugin_mistral_tasks::repo {

  notice('MODULAR: fuel_plugin_mistral_tasks/repo.pp')

  include apt
  
  apt::key {'fuel-infra':
    id     => '3E5CBCC6DF05CD6558A75DB1BCE5CC461FA22B08',
    source => 'http://perestroika-repo-tst.infra.mirantis.net/mos-repos/ubuntu/9.0/archive-mos9.0.key',
    
  }
  
  
  apt::source {'mos-proposed':
    location => 'http://perestroika-repo-tst.infra.mirantis.net/mos-repos/ubuntu/9.0',
    release  => 'mos9.0-proposed',
    repos    => 'main',
  }
  
  apt::pin { 'mos-proposed':
    priority        => 1050,
    release         => 'mos9.0-proposed',
    codename        => 'mos9.0',
    originator      => 'Mirantis',
    label           => 'mos9.0',
  }

}
