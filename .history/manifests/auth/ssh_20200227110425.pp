# @summary A manifest to configure SSH according to CIS hardening
# guidelines
#
# Section 5.2
#
# Hardens SSH in line with CIS standards for CentOS 7.x Servers
#
class cis_hardening::auth::ssh {

  # Ensure permissions on /etc/ssh/sshd_config are configured - Section 5.2.1
  file { '/etc/ssh/sshd_config':
    ensure => 'file',
    owner  => 'root',
    group  => 'root',
    mode   => '0600',
  }

  # Set sshd_config Options - Section 5.2.2
  exec { 'set_ssh_protocol':
    path    => '/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin',
    command => "perl -pi -e 's/^#Protocol.*$/Protocol 2/' /etc/ssh/sshd_config",
    onlyif  => 'test ! "grep ^Protocol /etc/ssh/sshd_config"',
  }

  # Set SSH LogLevel to INFO - Section 5.2.3
  exec { 'set_ssh_loglevel':
    path    => '/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin',
    command => "perl -pi -e 's/^#LogLevel.*$/LogLevel INFO/' /etc/ssh/sshd_config",
    onlyif  => 'test ! "grep ^LogLevel /etc/ssh/sshd_config"',
  }

  # Ensure SSH X11 Forwarding is disabled - Section 5.2.4
  exec { 'set_x11_forwarding':
    path    => '/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin',
    command => "perl -pi -e 's/^#X11Forwarding.*$/X11Forwarding no/' /etc/ssh/sshd_config",
    onlyif  => 'test ! "grep ^X11Forwarding /etc/ssh/sshd_config"',
  }

  # Ensure SSH MaxAuthTries is set to 4 or less - Section 5.2.5
  exec { 'set_ssh_maxauthtries':
    path    => '/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin',
    command => "perl -pi -e 's/^#MaxAuthTries.*$/MaxAuthTries 4/' /etc/ssh/sshd_config",
    onlyif  => 'test ! "grep ^MaxAuthTries /etc/ssh/sshd_config"',
  }

  # Ensure SSH IgnoreRhosts is enabled - Section 5.2.6
  exec { 'set_ssh_ignore_rhosts':
    path    => '/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin',
    command => "perl -pi -e 's/^#IgnoreRhosts.*$/IgnoreRhosts yes/' /etc/ssh/sshd_config",
    onlyif  => 'test ! "grep ^IgnoreRhosts /etc/ssh/sshd_config"',
  }

  # Ensure SSH HostBased Authentication is Disabled - Section 5.2.7
  exec { 'set_hosbasedauth_off':
    path    => '/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin',
    command => "perl -pi -e 's/^#HostbasedAuthentication.*$/HostbasedAuthentication no/' /etc/ssh/sshd_config",
    onlyif  => 'test ! "grep ^HostbasedAuthentication /etc/ssh/sshd_config"',
  }

  # Ensure SSH Root Login is Disabled - Section 5.2.8
  exec { 'set_rootlogin_no':
    path    => '/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin',
    command => "perl -pi -e 's/^#PermitRootLogin.*$/PermitRootLogin no/' /etc/ssh/sshd_config",
    onlyif  => 'test ! "grep ^PermitRootLogin /etc/ssh/sshd_config"',
  }

  # Ensure PermitEmptyPasswords is Disabled - Section 5.2.9
  exec { 'set_emptypasswords_off':
    path    => '/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin',
    command => "perl -pi -e 's/^#PermitEmptyPasswords.*$/PermitEmptyPasswords no/' /etc/ssh/sshd_config",
    onlyif  => 'test ! "grep ^PermitEmptyPasswords /etc/ssh/sshd_config"',
  }

  # Ensure SSH PermitUserEnvironment is Disabled - Section 5.2.10
  exec { 'set_permituserenv_off':
    path    => '/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin',
    command => "perl -pi -e 's/^#PermitUserEnvironment.*$/PermitUserEnvironment no/' /etc/ssh/sshd_config",
    onlyif  => 'test ! "grep ^PermitUserEnvironment /etc/ssh/sshd_config"',
  }

  # Ensure only approved MAC algorithms are used - Section 5.2.11

  # Ensure SSH Idle Timeout Interval is configured - Section 5.2.12
  exec { 'client_alive_interval':
    path    => '/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin',
    command => "perl -pi -e 's/^#ClientAliveInterval.*$/ClientAliveInterval 300/' /etc/ssh/sshd_config",
    onlyif  => 'test ! "grep ^ClientAliveInterval /etc/ssh/sshd_config"',
  }

  exec { 'client_alive_count_max':
    path    => '/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin',
    command => "perl -pi -e 's/^#ClientAliveCountMax.*$/ClientAliveCountMax 0/' /etc/ssh/sshd_config",
    onlyif  => 'test ! "grep ^ClientAliveCountMax /etc/ssh/sshd_config"',
  }

  # Ensure SSH LoginGraceTime is set to One Minute or Less - Section 5.2.13
  exec { 'login_grace_time':
    path    => '/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin',
    command => "perl -pi -e 's/^#LoginGraceTime.*$/LoginGraceTime 60/' /etc/ssh/sshd_config",
    onlyif  => 'test ! "grep ^LoginGraceTime /etc/ssh/sshd_config"',
  }

  # Ensure SSH Access is Limited - Section 5.2.14
  # Unused in sshd_config. Managed via IAM

  # Ensure SSH Warning Banner is Configured
  exec { 'set_ssh_banner':
    path    => '/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin',
    command => "perl -pi -e 's/^#Banner.*$/Banner /etc/issue.net/' /etc/ssh/sshd_config",
    onlyif  => 'test ! "grep ^Banner /etc/ssh/sshd_config"',
  }
}
