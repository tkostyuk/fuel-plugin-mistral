firewall { '300 mistral':
  chain  => 'INPUT',
  dport  => '8989',
  proto  => 'tcp',
  action => 'accept',
}
