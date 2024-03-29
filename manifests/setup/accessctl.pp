# @summary A manifest to configure Mandatory Access Control as per CIS hardening guidelines
#
# 1.6 - Mandatory Access Control
#
# @example
#   include cis_hardening::setup::accessctl
class cis_hardening::setup::accessctl {
  # Configure SELinux - Section 1.6.1

  # Ensure SELinux is installed - Section 1.6.1.1
  package { 'libselinux':
    ensure => 'present',
  }

  # Ensure SELinux is not disabled in bootloader configuration - Section 1.6.1.2
  file_line { 'grub_selinux_default':
    ensure => 'present',
    path   => '/etc/default/grub',
    line   => 'GRUB_CMDLINE_LINUX_DEFAULT="quiet"',
    match  => '^GRUB_CMDLINE_LINUX_DEFAULT\=',
  }

  file_line { 'grub_selinux':
    ensure => 'present',
    path   => '/etc/default/grub',
    line   => 'GRUB_CMDLINE_LINUX="audit=1"',
    match  => '^GRUB_CMDLINE_LINUX\=',
  }

  # Ensure SELINUX Policy is configured - Section 1.6.1.3
  file_line { 'selinux_policy':
    ensure => 'present',
    path   => '/etc/selinux/config',
    line   => 'SELINUXTYPE=targeted',
    match  => '^SELINUXTYPE\=',
  }

  # Ensure the SELinux mode is "enforcing" or "permisive - Section 1.6.1.4
  # Ensure the SELinux mode is "enforcing" - Section 1.6.1.5
  file_line { 'selinux_state':
    ensure => 'present',
    path   => '/etc/selinux/config',
    line   => 'SELINUX=enforcing',
    match  => '^SELINUX\=',
  }

  # Ensure no unconfined services exist - Section 1.6.1.6
  exec { 'unconfined_services':
    path    => '/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin',
    command => 'logger -p crit "Some unconfined services are running"',
    onlyif  => 'test `ps -eZ | grep unconfined_service_t`',
  }

  # Ensure SETroubleshoot is not installed - Section 1.6.1.7
  package { 'setroubleshoot':
    ensure => 'absent',
  }

  # Ensure MCS Translation Service is not installed - Section 1.6.1.8
  package { 'mcstrans':
    ensure => 'absent',
  }
}
