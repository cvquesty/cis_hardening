# @summary A manifest to configure additional process hardening according to CIS hardening guidelines
#
# Section 1.5 - Additional Process Hardening
#
# @example
#   include cis_hardening::setup::prochardening
class cis_hardening::setup::prochardening {

  # Restart sysctl for prochardening items
  exec { 'restart_prochardening_sysctl':
    path    => '/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin',
    command => '/sbin/sysctl -p',
  }

  # Ensure Core Dumps are restricted - Section 1.5.1
  file_line { 'core_limits':
    ensure => 'present',
    path   => '/etc/security/limits.conf',
    line   => '* hard core 0',
  }

  file_line { 'fs_dumpable':
    ensure => 'present',
    path   => '/etc/sysctl.d/99-sysctl.conf',
    line   => 'fs.suid_dumpable = 0',
    notify => Exec['restart_prochardening_sysctl'],
  }

  # Ensure XD/NX support is enabled - Section 1.5.2
  #
  # NOTE: Enabled by default on 64-bit systems

  # Ensure Address space layout randomization - Section 1.5.3
  file_line { 'randomize_va_space':
    ensure => 'present',
    path   => '/etc/sysctl.d/99-sysctl.conf',
    line   => 'kernel.randomize_va_space = 2',
    notify => Exec['restart_prochardening_sysctl'],
  }

  # Ensure prelink is disabled - Section 1.5.3
  package { 'prelink':
    ensure => 'absent',
  }
}
