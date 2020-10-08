# @summary A manifest to configure system services according to CIS
# hardening guidelines
#
# Section 2
#
# Enforces CIS recommendations for System Services according to published 
# hardening guidelines for CentOS 7.x systems
#
class cis_hardening::services {

  include cis_hardening::services::inetd
  include cis_hardening::services::special
  include cis_hardening::services::svcclients

}
