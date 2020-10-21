# @summary A manifest to configure user and group settings according to CIS Hardening Guidelines
#
# Section 6.2 - User Groups and Settings
#
# @example
#   include cis_hardening::maint::usergroups
class cis_hardening::maint::usergroups {

  # Ensure password fields are not empty - Section 6.2.1
  #
  exec { 'shadowed_passwords_check':
    path => '/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr'
  }

}
