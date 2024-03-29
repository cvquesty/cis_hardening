# @summary A manifest to configure IPv6 according to CIS hardening guidelines
#
# Section 3.1 - Unused Network protocols and devices
#
# @example
#   include cis_hardening::network::unused_protocols
class cis_hardening::network::unused_protocols {
  # Restart sysctl for IPv6
  exec { 'restart_ipv6_sysctl':
    path    => '/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin',
    command => '/sbin/sysctl -p',
  }

  # Disable IPv6 - Section 3.1.1
  file_line { 'disable_ipv6_sysctl_default':
    ensure => 'present',
    path   => '/etc/sysctl.d/99-sysctl.conf',
    line   => 'net.ipv6.conf.default.disable_ipv6 = 1',
    notify => Exec['restart_ipv6_sysctl'],
  }

  file_line { 'disable_ipv6_sysctl_all':
    ensure => 'present',
    path   => '/etc/sysctl.d/99-sysctl.conf',
    line   => 'net.ipv6.conf.all.disable_ipv6 = 1',
    notify => Exec['restart_ipv6_sysctl'],
  }

  # Ensure Wireless Interfaces are disabled - Section 3.1.2
  # Create fact to find wireless interfaces for disabling
  #   Ticket Opened - https://github.com/cvquesty/cis_hardening/issues/21
}
