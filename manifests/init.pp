# @summary A module to implement CIS hardening standards for CentOS 7.x Systems
#
# This is the main entry point that selects each of the domains as outlined in CIS Hardening v3.0.0
# for CentOS 7 systems.
#
class cis_hardening {
  include cis_hardening::setup        # Section 1 - Initial Setup
  include cis_hardening::services     # Section 2 - Services
  include cis_hardening::network      # Section 3 - Network Configuration
  include cis_hardening::logaudit     # Section 4 - Logging and Auditing
  include cis_hardening::auth         # Section 5 - Access, Authentication, and Authorization
  include cis_hardening::maint        # Section 6 - System Maintenance
}
