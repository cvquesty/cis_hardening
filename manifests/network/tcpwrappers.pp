# @summary A manifest to configure TCP Wrappers according to CIS Hardening Guidelines
#
# Section 3.4
#
# @example
#   include cis_hardening::network::tcpwrappers
class cis_hardening::network::tcpwrappers {

  # Verify TCP Wrappers are installed - Section 3.4.1
  package { 'tcp_wrappers':
    ensure => 'present',
  }

  # Ensure /etc/hosts.allow is configured - Section 3.4.2, 3.4.4
  file { '/etc/hosts.allow':
    ensure => 'present',
    owner  => 'root',
    group  => 'root',
    mode   => '0644',
  }

  # Ensure /etc/hosts.deny is configured - Section 3.4.3, 3.4.5
  #file { '/etc/hosts.deny':
  #  ensure  => 'present',
  #  owner   => 'root',
  #  group   => 'root',
  #  mode    => '0644',
  #  content => 'ALL: ALL',
  #}
  #
  # NOTE: Ensure hosts.allow exists and is complete before uncommenting the above, or you will lose access
  # to the node.



}
