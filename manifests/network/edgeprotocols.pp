# @summary A manifest to configure edge protocols in accordance with CIS Hardening Guidelines
#
# Section 3.4 - Uncommon Network Protocols
#
# @example
#   include cis_hardening::network::edgeprotocols
class cis_hardening::network::edgeprotocols {

  # Ensure DCCP is disabled - Section 3.4.1
  file_line { 'dccp_disable':
    ensure => 'present',
    path   => '/etc/modprobe.d/CIS.conf',
    line   => 'install dccp /bin/true',
  }

  # Ensure SCTP is disabled - Section 3.4.2
  file_line { 'sctp_disable':
    ensure => 'present',
    path   => '/etc/modprobe.d/CIS.conf',
    line   => 'install sctp /bin/true',
  }

}
