# @summary A short summary of the purpose of this class
#
# Section 5.2 - Configure sudo
#
# @example
#   include cis_hardening::auth::sudo
class cis_hardening::auth::sudo {
  # Ensure sudo is installed - Section 5.2.1
  package { 'sudo':
    ensure => 'installed',
  }

  # Ensure sudo commands use pty - Section 5.2.2
  file { '/etc/sudoers.d/cis_sudoers_defaults.conf':
    ensure => 'file',
    owner  => 'root',
    group  => 'root',
    mode   => '0440',
  }

  file_line { 'defaults_pty':
    ensure  => 'present',
    path    => '/etc/sudoers.d/cis_sudoers_defaults.conf',
    line    => 'Defaults use_pty',
    require => File['/etc/sudoers.d/cis_sudoers_defaults.conf'],
  }

  # Ensure sudo log file exists - Section 5.2.3
  file_line { 'defaults_sudo_logfile':
    ensure  => 'present',
    path    => '/etc/sudoers.d/cis_sudoers_defaults.conf',
    line    => 'Defaults logfile="/var/log/sudo.log"',
    require => File['/etc/sudoers.d/cis_sudoers_defaults.conf'],
  }
}
