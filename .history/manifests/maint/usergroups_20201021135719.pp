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
    onlyif  => "test ! `awk -F: '($2 != "x" )' /etc/passwd`",
  }

  # Ensure /etc/shadow password fields are not empty - Section 6.2.2
  exec { 'shadow_password_field_check':
    path    => '/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin',
    command => 'logger -p crit "Shadow Password Fields Empty. Check manually."',
    onlyif  => "test ! `awk -F: '($2 == "" )' /etc/shadow |wc -l` -gt 0",
  }

  # Ensure the root account is the only UID 0 Account - Section 6.2.3
  exec { 'only_one_uid0':
    path    => '/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin',
    command => 'logger -p crit "More than one user has a UID of 0"',
    onlyif  => "test ! `awk -F: '($3 == 0) { print $1 }' /etc/passwd |grep -v root`",
  }

}
