# @summary A manifest to configure logging and auditing according
# to CIS Hardening guidelines
#
# Section 4 - Logging and Auditing
#
# Enforces CIS recommendations for logging and auditing  according to 
# published hardening guidelines for CentOS 7.x systems
#
class cis_hardening::logaudit {

  include cis_hardening::logaudit::accounting     # Section 4.1 - Configure System Accounting
  include cis_hardening::logaudit::logging        # Section 4.2 - Configure Logging
  include cis_hardening::logaudit::logrotate      # Section 4.2.4 

}
