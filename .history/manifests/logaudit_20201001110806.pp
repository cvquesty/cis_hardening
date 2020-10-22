# @summary A manifest to configure logging and auditing according
# to CIS Hardening guidelines
#
# Section 4
#
# Enforces CIS recommendations for logging and auditing  according to 
# published hardening guidelines for CentOS 7.x systems
#
class cis_hardening::logaudit {

  include cis_hardening::logaudit::accounting
  include cis_hardening::logaudit::logging
  include cis_hardening::logaudit::logrotate

}
