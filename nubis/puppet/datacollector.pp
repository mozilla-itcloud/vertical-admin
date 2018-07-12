file { '/opt/mi':
  ensure => directory,
  owner  => 'root',
  group  => 'root',
}

file { '/opt/mi/datacollector':
  ensure  => directory,
  recurse => true,
  purge   => false,
  owner   => 'root',
  group   => 'root',
  source  => 'puppet:///nubis/files/datacollector',
  require => [
    File['/opt/mi'],
  ],
}

systemd::unit_file { 'datacollector.service':
  content => @("EOT")
[Unit]
Description=Metrics Insights DataCollector
Wants=basic.target
After=basic.target network.target

[Service]
Restart=on-failure
RestartSec=10s

ExecStart=/bin/bash -c '. /etc/profile.d/proxy.sh && /opt/mi/datacollector/bin/insightd -f /etc/datacollector/config.ini -l DEBUG start'

EOT
} ~> service { 'datacollector':
  ensure => 'stopped',
  enable => false,
}