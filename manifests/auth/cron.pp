# @summary A manifest to ensure the cron daemon is enabled
#
# Section 5.1
#
class cis_hardening::auth::cron {

  # Install Cronie to run cron
  package { 'cronie':
    ensure => 'installed',
  }

  # Enable Cron Daemon - Section 5.1.1
  service { 'crond':
    ensure     => 'running',
    hasstatus  => true,
    hasrestart => true,
    enable     => true,
    require    => Package['cronie'],
  }

  # Ensure permissions on /etc/crontab are configured - Section 5.1.2
  file { '/etc/crontab':
    ensure => 'present',
    owner  => 'root',
    group  => 'root',
    mode   => '0644',
  }

  # Ensure permissions on /etc/cron.hourly are configured - Section 5.1.3
  file { '/etc/cron.hourly':
    ensure => 'directory',
    owner  => 'root',
    group  => 'root',
    mode   => '0700',
  }

  # Ensure permissions on /etc/cron.daily are configured - Section 5.1.4
  file { '/etc/cron.daily':
    ensure => 'directory',
    owner  => 'root',
    group  => 'root',
    mode   => '0700',
  }

  # Ensure permissions on /etc/cron.weekly are configured - Section 5.1.5
  file { '/etc/cron.weekly':
    ensure => 'directory',
    owner  => 'root',
    group  => 'root',
    mode   => '0700',
  }

  # Ensure permissions on /etc/cron.monthly are configured - Section 5.1.6
  file { '/etc/cron.monthly':
    ensure => 'directory',
    owner  => 'root',
    group  => 'root',
    mode   => '0700',
  }

  # Ensure permissions on /etc/cron.d are configured - Section 5.1.7
  file { '/etc/cron.d':
    ensure => 'directory',
    owner  => 'root',
    group  => 'root',
    mode   => '0700',
  }

  # Ensure at/cron is restricted to authorized users - Section 5.1.8
  exec { 'rm_atdeny':
    path    => '/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin',
    command => 'rm -f /etc/at.deny',
    onlyif  => 'test -f /etc/at.deny',
  }

  exec { 'rm_crondeny':
    path    => '/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin',
    command => 'rm -f /etc/cron.deny',
    onlyif  => 'test -f /etc/cron.deny',
  }

  file { '/etc/cron.allow':
    ensure => 'file',
    owner  => 'root',
    group  => 'root',
    mode   => '0600',
  }

  file { '/etc/at.allow':
    ensure => 'file',
    owner  => 'root',
    group  => 'root',
    mode   => '0600',
  }

}
