# @summary A manifest to configure additional process hardening according to CIS hardening guidelines
#
# Section 1.6 - Additional Process Hardening
#
# @example
#   include cis_hardening::setup::prochardening
class cis_hardening::setup::prochardening {

  # Restart sysctl for prochardening items
  exec { 'restart_prochardening_sysctl':
    path    => '/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin',
    command => '/sbin/sysctl -p',
  }

  # Ensure Core Dumps are restricted - Section 1.6.1
  file { '/etc/security/limits.d/cis_coredumps.conf':
    ensure  => 'present',
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    content => '* hard core 0',
    notify => Exec['restart_prochardening_sysctl'],
  }

  file_line { 'fs_dumpable':
    ensure => 'present',
    path   => '/etc/sysctl.d/99-sysctl.conf',
    line   => 'fs.suid_dumpable = 0',
    notify => Exec['restart_prochardening_sysctl'],
  }

  # Ensure XD/NX support is enabled - Section 1.6.2
  #
  # NOTE: Enabled by default on 64-bit systems

  # Ensure Address space layout randomization (ASLR) is enabled - Section 1.6.3
  file_line { 'randomize_va_space':
    ensure => 'present',
    path   => '/etc/sysctl.d/99-sysctl.conf',
    line   => 'kernel.randomize_va_space = 2',
    notify => Exec['restart_prochardening_sysctl'],
  }

  # Ensure prelink is disabled - Section 1.6.4

  # First restore binaries to normal:
  package { 'prelink':
    ensure => 'absent',
  }
}
