# @summary A manifest to configure Authentication and Authrization
# according to CIS hardening guidelines
#
# Section 5
#
# Enforces CIS recommendations for Authentication and Authorization  
# according to published hardening guidelines for CentOS 7.x systems
# 
class cis_hardening::auth {

  include cis_hardening::auth::accounts
  include cis_hardening::auth::cron
  include cis_hardening::auth::pam
  include cis_hardening::auth::ssh
  include cis_hardening::auth::su

}
