# @summary A manifest to configure network services and stack according
# to CIS hardening guidelines
#
# Section 3
#
# Enforces CIS recommendations for network services configuration
# according to published hardening guidelines for CentOS 7.x systems
#
class cis_hardening::network {

  include cis_hardening::network::netparams
  include cis_hardening::network::tcpwrappers
  include cis_hardening::network::ipv6
  include cis_hardening::network::firewall
  include cis_hardening::network::edgeprotocols

}
