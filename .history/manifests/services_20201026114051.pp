# @summary A manifest to configure system services according to CIS
# hardening guidelines
#
# Section 2
#
# Enforces CIS recommendations for System Services according to published 
# hardening guidelines for CentOS 7.x systems
#
class cis_hardening::services {

  include cis_hardening::services::inetd          # Section 2.1 - Inetd Services
  include cis_hardening::services::special        # Section 2.2 - Special Purpose Services
  include cis_hardening::services::svcclients     

}
