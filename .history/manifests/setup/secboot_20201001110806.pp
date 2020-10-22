# @summary A manifest to configure secure boot settings according to CIS hardening guidelines
#
# Section 1.4 - Secure Boot Settings
#
# @example
#   include cis_hardening::setup::secboot
class cis_hardening::setup::secboot {

  # Ensure permissions on bootloader config are configured - Section 1.4.1
  if $facts['virtual'] == 'docker' {
  } else {
    file { '/boot/grub2/grub.cfg':
      ensure => 'present',
      owner  => 'root',
      group  => 'root',
      mode   => '0600',
    }

    file { '/boot/grub2/user.cfg':
      ensure => 'present',
      owner  => 'root',
      group  => 'root',
      mode   => '0600',
    }

    # Ensure bootloader password is set - Section 1.4.2
    #
    # NOTE: Be sure to set boot password if physical security is unable to be maintained. Use the command:
    #   grub2-setpassword
    #
    # to achieve this goal.

    # Ensure authentication required for single user mode - Section 1.4.3
    #
    # NOTE: Check for sulogin with "grep /sbin/sulogin /usr/lib/systemd/system/rescue.service" command
    # Remediate manually if desired
    #
    file_line { 'sulogin_rescue':
      ensure => 'present',
      path   => '/usr/lib/systemd/system/rescue.service',
      line   => 'ExecStart=-/bin/sh -c "/usr/sbin/sulogin; /usr/bin/systemctl --fail --no-block default"',
    }

    file_line { 'sulogin_emergency':
      ensure => 'present',
      path   => '/usr/lib/systemd/system/emergency.service',
      line   => 'ExecStart=-/bin/sh -c "/usr/sbin/sulogin; /usr/bin/systemctl --fail --no-block default"',
    }
  }
}
