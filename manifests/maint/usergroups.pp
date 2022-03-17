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
    command => "sed -e 's/^\\([a-zA-Z0-9_]*\\):[^:]*:/\\1:x:/' -i /etc/passwd",
    onlyif  => "test ! `cat /etc/passwd | awk -F: '{print \$2}' |grep -v x`",
  }

  # Ensure /etc/shadow password fields are not empty - Section 6.2.2
  exec { 'shadow_password_field_check':
    path    => '/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin',
    command => 'logger -p crit "Shadow Password Fields Empty. Check manually."',
    onlyif  => "test `cat /etc/shadow |awk '{print \$2}'`",
  }

  # Ensure the root account is the only UID 0 Account - Section 6.2.9
  exec { 'only_one_uid0':
    path    => '/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin',
    command => 'logger -p crit "More than one user has a UID of 0"',
    onlyif  => "test ! `awk -F: '(\$3 == 0) { print \$1 }' /etc/passwd |grep -v root`",
  }

  # Ensure root PATH integrity - Section 6.2.10
    # Check for empty Directory in path
    exec { 'check_empty_root_path_dir':
      path    => '/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin',
      command => 'logger -p crit "Empty Directory in root PATH (::)"',
      onlyif  => 'test `echo "$PATH" | grep -q "::"`',
    }

    # Check for trailing : in root PATH
    exec { 'check_trailing_colon_root_path':
      path    => '/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin',
      command => 'logger -p crit "Trailing : in root PATH."',
      onlyif  => 'test ! `echo "$PATH" |grep -q ":$"`',
    }

    # TODO: Write fact to Ensure all User home directories exist - 6.2.11
    # TODO: Write a fact to ensure users own their home directories - 6.2.12
    # TODO: Write a fact to ensure users' home directory permissions are 750 or more restrictive - 6.2.13
    # TODO: Write a fact to ensure users' dotfiles are not group or world writable - 6.2.14
    # TODO: Write a fact to ensure no user has a .forward file - 6.2.15
    # TODO: Write a fact to ensure no user as a .netrc file - 6.2.16
    # TODO: Write a fact to ensure no users have .rhosts files - 6.2.17

}
