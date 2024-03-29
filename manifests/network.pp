# @summary A manifest to configure network services and stack according
# to CIS hardening guidelines
#
# Section 3 - Network Configuration
#
# Enforces CIS recommendations for network services configuration
# according to published hardening guidelines for CentOS 7.x systems
#
class cis_hardening::network {
  include cis_hardening::network::unused_protocols # Section 3.1 - Disable Unused Protocols and Devices
  include cis_hardening::network::netparams        # Section 3.2/3.3 - Network Parameters (Host and Router)
  include cis_hardening::network::edgeprotocols    # Section 3.4 - Uncommon Network Protocols
  include cis_hardening::network::firewall         # Section 3.5 - Firewall Configuration
}
