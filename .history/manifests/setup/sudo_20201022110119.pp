# @summary A short summary of the purpose of this class
#
# Section 1.3 - Configure sudo
#
# @example
#   include cis_hardening::setup::sudo
class cis_hardening::setup::sudo {

  # Ensure sudo is installed - Section 1.3.1
  package { 'sudo':
    ensure => 'installed',
  }

  # Ensure sudo commands use pty - Section 1.3.2
  file { '/etc/sudoers.d/cis_sudoers_defaults.conf':
    ensure => 'present',
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

  # Ensure sudo log file exists - Section 1.3.3
  file_line { 'defaults_sudo_logfile':
    ensure => 'present',
  }

}
