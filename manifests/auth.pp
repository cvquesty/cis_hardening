# @summary A manifest to configure Authentication and Authrization
# according to CIS hardening guidelines
#
# Section 5 - Access, Authentication, and Authorization
#
# Enforces CIS recommendations for Authentication and Authorization
# according to published hardening guidelines for CentOS 7.x systems
#
class cis_hardening::auth {
  include cis_hardening::auth::cron       # Section 5.1 - Configure Time-based Job Schedulers
  include cis_hardening::auth::sudo       # Section 5.2 - Configure sudo
  include cis_hardening::auth::ssh        # Section 5.3 - Configure SSH Server
  include cis_hardening::auth::pam        # Section 5.4 - Configure PAM
  include cis_hardening::auth::accounts   # Section 5.5/5.6 - User Accounts and Environment
  include cis_hardening::auth::su         # Section 5.7 - Root Account & su configuration
}
