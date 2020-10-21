# @summary A manifest to configure user and group settings according to CIS Hardening Guidelines
#
# Section 6.2 - User Groups and Settings
#
# @example
#   include cis_hardening::maint::usergroups
class cis_hardening::maint::usergroups {

  # Ensure accounts in /etc/passwd use shadowed passwords - Section 6.2.1
  #
  exec { 'shadowed_passwords_check':
    path    => '/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin',
    command => "sed -e 's/^\([a-zA-Z0-9_]*\):[^:]*:/\1:x:/' -i /etc/passwd",
    onlyif  => "awk -F: '($2 != "x" ) { print $1 " is not set to shadowed passwords "}' /etc/passwd",
  }

}
