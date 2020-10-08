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

  file_line { 'set_ssh_protocol':
    ensure => 'present',
    path   => '/etc/ssh/sshd_config',
    line   => 'Protocol 2',
  }

  # Set SSH LogLevel to INFO - Section 5.2.3
  file_line { 'set_ssh_loglevel':
    ensure => 'present',
    path   => '/etc/ssh/sshd_config',
    line   => 'LogLevel INFO',
  }

  # Ensure SSH X11 Forwarding is disabled - Section 5.2.4
  file_line { 'set_x11_forwarding':
    ensure => 'present',
    path   => '/etc/ssh/sshd_config',
    line   => 'X11Forwarding no',
  }

  # Ensure SSH MaxAuthTries is set to 4 or less - Section 5.2.5
  file_line { 'set_ssh_maxauthtries':
    ensure => 'present',
    path   => '/etc/ssh/sshd_config',
    line   => 'MaxAuthTries 4',
  }

  # Ensure SSH IgnoreRhosts is enabled - Section 5.2.6
  file_line { 'set_ssh_ignore_rhosts':
    ensure => 'present',
    path   => '/etc/ssh/sshd_config',
    line   => 'IgnoreRhosts yes',
  }

  # Ensure SSH HostBased Authentication is Disabled - Section 5.2.7
  file_line { 'set_hostbasedauth_off':
    ensure => 'present',
    path   => '/etc/ssh/sshd_config',
    line   => 'HostBasedAuthentication no',
  }

  # Ensure SSH Root Login is Disabled - Section 5.2.8
  file_line { 'set_rootlogin_no':
    ensure => 'present',
    path   => '/etc/ssh/sshd_config',
    line   => 'PermitRootLogin no',
  }

  # Ensure PermitEmptyPasswords is Disabled - Section 5.2.9
  file_line { 'set_emptypasswords_off':
    ensure => 'present',
    path   => '/etc/ssh/sshd_config',
    line   => 'PermitEmptyPasswords no',
  }

  # Ensure SSH PermitUserEnvironment is Disabled - Section 5.2.10
  file_line { 'set_permituserenv_off':
    ensure => 'present',
    path   => '/etc/ssh/sshd_config',
    line   => 'PermitUserEnvironment no',
  }

  # Ensure only approved MAC algorithms are used - Section 5.2.11

  # Ensure SSH Idle Timeout Interval is configured - Section 5.2.12
  file_line { 'client_alive_interval':
    ensure => 'present',
    path   => '/etc/ssh/sshd_config',
    line   => 'ClientAliveInterval 300',
  }

  file_line { 'client_alive_count_max':
    ensure => 'present',
    path   => '/etc/ssh/sshd_config',
    line   => 'ClientAliveCountMax 0',
  }

  # Ensure SSH LoginGraceTime is set to One Minute or Less - Section 5.2.13
  file_line { 'login_grace_time':
    ensure => 'present',
    path   => '/etc/ssh/sshd_config',
    line   => 'LoginGraceTime 60',
  }

  # Ensure SSH Access is Limited - Section 5.2.14
  # Unused in sshd_config. Managed via IAM

  # Ensure SSH Warning Banner is Configured - Section 5.2.15
  file_line { 'set_ssh_banner':
    ensure => 'present',
    path   => '/etc/ssh/sshd_config',
    line   => 'Banner /etc/issue.net',
  }
}
