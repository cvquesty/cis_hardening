# @summary A manifest to configure secure boot settings according to CIS hardening guidelines
#
# Section 1.4 - Secure Boot Settings
#
# @example
#   include cis_hardening::setup::secboot
class cis_hardening::setup::secboot {
  # Ensure bootloader password is set - Section 1.4.1
  # Check that Grub Password is set:
  #
  #   grep "^\s*GRUB2_PASSWORD" /boot/grub2/user.cfg
  #
  # If not, the password can be set interactively with the following command:
  #
  #   grub2-setpassword

  # Ensure permissions on bootloader config are configured - Section 1.4.2
  if $facts['virtual'] == 'docker' {
  } else {
    file { '/boot/grub2/grub.cfg':
      ensure => 'file',
      owner  => 'root',
      group  => 'root',
      mode   => '0600',
    }

    file { '/boot/grub2/user.cfg':
      ensure => 'file',
      owner  => 'root',
      group  => 'root',
      mode   => '0600',
    }

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
