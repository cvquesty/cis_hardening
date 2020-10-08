# @summary A manifest to configure edge protocols in accordance with CIS Hardening Guidelines
#
# Section 3.5
#
# @example
#   include cis_hardening::network::edgeprotocols
class cis_hardening::network::edgeprotocols {

  # Ensure DCCP is disabled - Section 3.5.1
  file_line { 'dccp_disable':
    ensure => 'present',
    path   => '/etc/modprobe.d/CIS.conf',
    line   => 'install dccp /bin/true',
  }

  # Ensure SCTP is disabled - Section 3.5.2
  file_line { 'sctp_disable':
    ensure => 'present',
    path   => '/etc/modprobe.d/CIS.conf',
    line   => 'install sctp /bin/true',
  }

  # Ensure RDS is disabled - Section 3.5.3
  file_line { 'rds_disable':
    ensure => 'present',
    path   => '/etc/modprobe.d/CIS.conf',
    line   => 'install rds /bin/true',
  }

  # Ensure TIPC is disabled - Section 3.5.4
  file_line { 'tipc_disable':
    ensure => 'present',
    path   => '/etc/modprobe.d/CIS.conf',
    line   => 'install tipc /bin/true',
  }
}
