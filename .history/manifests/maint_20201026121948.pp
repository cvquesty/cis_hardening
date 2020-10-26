# @summary A manifest to configure system maintenance related 
# components in accordance with CIS hardening guidelines
#
# Section 6 - System Maintenance
#
# Enforces CIS recommendations for System Maintenance according to 
# published hardening guidelines for CentOS 7.x systems
# 
#
class cis_hardening::maint {

  include cis_hardening::maint::fileperms     # Section 6.1 - System Dil 
  include cis_hardening::maint::usergroups

}
