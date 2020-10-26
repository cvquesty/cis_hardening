# @summary A module to implement CIS hardening standards for CentOS 7.x Systems
#
# This is the main entry point that selects each of the domains as outlined in CIS Hardening v3.0.0 
# for CentOS 7 systems. 
#
class cis_hardening {

  include cis_hardening::auth
  include cis_hardening::logaudit
  include cis_hardening::maint
  include cis_hardening::network
  include cis_hardening::services   
  include cis_hardening::setup        # Section 1 - Initial Setup

}
