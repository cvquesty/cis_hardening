# @summary A short summary of the purpose of this class
#
# Section 1.3 - Filesystem Integrity Checking
#
# @example
#   include cis_hardening::setup::fim
class cis_hardening::setup::fim {

  # Ensure AIDE is installed - Section 1.3.1
  package { 'aide':
    ensure => 'present',
  }

  # Initialize AIDE
  exec { 'aideinit':
    path    => '/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin',
    command => 'aide --init',
    unless  => 'test -f /var/lib/aide/aide.db.new.gz',
    require => Package['aide'],
  }

  exec { 'bkup_aide':
    path    => '/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin',
    command => 'mv /var/lib/aide/aide.db.new.gz /var/lib/aide/aide.db.gz',
    onlyif  => 'test -f /var/lib/aide/aide.db.new.gz',
    unless  => 'test -f /var/lib/aide/aide.db.gz',
    require => Exec['aideinit'],
  }

  # Ensure filesystem integrity is regularly checked - Section 1.3.2
  cron { 'aide':
    command => '/usr/sbin/aide --check',
    user    => 'root',
    hour    => 5,
    minute  => 0,
  }

}
