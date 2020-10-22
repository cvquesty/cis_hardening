# @summary A short summary of the purpose of this class
#
# 3.5 - Firewall Configuration
#
# @example
#   include cis_hardening::network::firewall
class cis_hardening::network::firewall {

  # Configure FirewallD - Section 3.5.1
  # This specification does not include the installation and usage of FirewallD, but IPTables.
  # Below is the configuration of IPTables as defined.
  #
  # FirewallD Controls skipped or ignored for this specification:
  #
  # 3.5.1.1, 3.5.1.2

  # 

  package { 'iptables':
    ensure => 'present',
  }

  # Ensure Default deny Firewall Policy - Section 3.6.2
  # Ensure loopback traffic is configured - Section 3.6.3
  # Ensure outbound and established connections are configured - Section 3.6.4
  # Ensure Firewall rules exist for all open ports - Section 3.6.5
  # Ensure wireless interfaces are disabled - Section 3.7

  # Place IPTABLES config file
  file { '/etc/sysconfig/iptables':
    ensure => 'present',
    owner  => 'root',
    group  => 'root',
    mode   => '0600',
    source => 'puppet:///modules/cis_hardening/iptables.conf',
  }
}
