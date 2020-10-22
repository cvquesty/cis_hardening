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
  file { '/etc/sudoers.d/cis_defaults.conf'
    ensure => 'present',
    owner  => 'root',
  }

}
