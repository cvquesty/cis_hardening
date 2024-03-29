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
  # 3.5.1.1, 3.5.1.2, 3.5.1.4, 3.5.1.5, 3.5.1.6, 3.5.1.7

  # Ensure FirewallD is not installed or stopped and Masked - 3.5.2.2, 3.5.3.1.3
  package { 'firewalld':
    ensure => 'absent',
  }

  # Ensure nftables is not installed or stopped and masked - 3.5.1.3, 3.5.3.1.2
  package { 'nftables':
    ensure => 'absent',
  }

  # Configure nftables - Section 3.5.2
  # We have disabled nftables above, therefore the controls to be skiped or ignored are:
  #
  # 3.5.2.1, 3.5.2.2, 3.5.2.3, 3.5.2.4, 3.5.2.5, 3.5.2.6, 3.5.2.7, 3.5.2.8, 3.5.2.9, 3.5.2.10
  # 3.5.2.11,

  # Configure IPTables - Section 3.5.3
  # 3.5.3.1 - Configure Software

  # Ensure IPTables packages are installed - 3.5.3.1.1
  package { 'iptables':
    ensure => 'present',
  }

  package { 'iptables-services':
    ensure => 'present',
  }

  # Configure IPv4 IPTables - 3.5.3.2
  # Ensure loopback traffic is configured - Section 3.5.3.2.1
  # Ensure outbound and established connections are configured - Section 3.5.3.2.2
  # Ensure Firewall rules exist for all open ports - Section 3.5.3.2.3
  # Ensure Default deny Firewall Policy - Section 3.5.3.2.4
  # Ensure IPTables rules are saved - Section 3.5.3.2.5

  # Ensure IPTables is enabled and running - Section 3.5.3.2.6

  service { 'iptables':
    ensure     => 'running',
    enable     => true,
    hasstatus  => true,
    hasrestart => true,
  }

  # NOTE: Disabled for local testing ONLY. May be enabled on physical infrastructure

  # Place IPTABLES config file
  file { '/etc/sysconfig/iptables':
    ensure => 'file',
    owner  => 'root',
    group  => 'root',
    mode   => '0600',
    source => 'puppet:///modules/cis_hardening/iptables.conf',
  }

  # Configure IPv6 IPTables - Section 3.5.3.3
  #
  # IPv6 is disabled in this iteration. As such, all IPv6 IPTables configuration elements will
  # be ignored. Those controls are:
  #
  # 3.5.3.3.1, 3.5.3.3.2, 3.5.3.3.3, 3.5.3.3.4, 3.5.3.3.5, 3.5.3.3.6,
}
