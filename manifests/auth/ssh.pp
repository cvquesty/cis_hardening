# @summary A manifest to configure SSH according to CIS hardening
# guidelines
#
# Section 5.3 - Configure SSH Server
#
# Hardens SSH in line with CIS standards for CentOS 7.x Servers
#
class cis_hardening::auth::ssh {

  # Ensure permissions on /etc/ssh/sshd_config are configured - Section 5.3.1
  file { '/etc/ssh/sshd_config':
    ensure => 'file',
    owner  => 'root',
    group  => 'root',
    mode   => '0600',
  }

  # Ensure permissions on SSH private host key files are configured - Section 5.3.2
  exec { 'set_sshprivkey_perms':
    path    => '/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin',
    command => "find /etc/ssh -xdev -type f -name 'ssh_host_*_key' -exec chmod u-x,g-wx,o-rwx {} \\;",
  }

  exec { 'set_sshprivkey_owner':
    path    => '/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin',
    command => "find /etc/ssh -xdev -type f -name 'ssh_host_*_key' -exec chown root:ssh_keys {} \\;",
  }

  # Ensure permissions on SSH public host key files are configured - Section 5.3.3
  exec { 'set_sshpubkey_perms':
    path    => '/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin',
    command => "find /etc/ssh -xdev -type f -name 'ssh_host_*_key.pub' -exec chmod u-x,go-wx {} \\;",
  }

  exec { 'set_sshpubkey_owner':
    path    => '/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin',
    command => "find /etc/ssh -xdev -type f -name 'ssh_host_*_key.pub' -exec chown root:root {} \\;",
  }

  # Ensure SSH access is limited - Section 5.3.4
  #
  # NOTE: To use this feature, you must specify the users or groups you wish to allow or deny
  # connection to the system via SSH. The below stanzas will allow you to do this by replacing
  # the "<userlist>" or "<grouplist>" items with a list of space-seaprated usernames
  #
  # file_line { 'allowusers_ssh':
  #   ensure => 'present',
  #   path   => '/etc/ssh/sshd_config',
  #   line   => 'AllowUsers <userlist>'
  # }
  #
  # file_line { 'allowgroups_ssh':
  #   ensure => 'present',
  #   path   => '/etc/ssh/sshd_config',
  #   line   => 'AllowGroups <grouplist>'
  # }
  #
  # file_line { 'denyusers_ssh':
  #   ensure => 'present',
  #   path   => '/etc/ssh/sshd_config',
  #   line   => 'DenyUsers <userlist>'
  # }
  #
  # file_line { 'denygroups_ssh':
  #   ensure => 'present',
  #   path   => '/etc/ssh/sshd_config',
  #   line   => 'DenyGroups <grouplist>'
  # }

  # Ensure SSH LogLevel is appropriate - Section 5.3.5
  file_line { 'set_ssh_loglevel':
    ensure => 'present',
    path   => '/etc/ssh/sshd_config',
    line   => 'LogLevel INFO',
    match  => '^LogLevel\ ',
  }

  # Ensure SSH X11 Forwarding is disabled - Section 5.3.6
  file_line { 'set_x11_forwarding':
    ensure => 'present',
    path   => '/etc/ssh/sshd_config',
    line   => 'X11Forwarding no',
    match  => '^X11Forwarding\ ',
  }

  # Ensure SSH MaxAuthTries is set to 4 or less - Section 5.3.7
  file_line { 'set_ssh_maxauthtries':
    ensure => 'present',
    path   => '/etc/ssh/sshd_config',
    line   => 'MaxAuthTries 4',
    match  => '^MaxAuthTries\ '
  }

  # Ensure SSH IgnoreRhosts is enabled - Section 5.3.8
  file_line { 'set_ssh_ignore_rhosts':
    ensure => 'present',
    path   => '/etc/ssh/sshd_config',
    line   => 'IgnoreRhosts yes',
    match  => '^IgnoreRhosts\ ',
  }

  # Ensure SSH HostBased Authentication is Disabled - Section 5.3.9
  file_line { 'set_hostbasedauth_off':
    ensure => 'present',
    path   => '/etc/ssh/sshd_config',
    line   => 'HostBasedAuthentication no',
    match  => '^HostBasedAuthentication\ ',
  }

  # Ensure SSH Root Login is Disabled - Section 5.3.10
  file_line { 'set_rootlogin_no':
    ensure => 'present',
    path   => '/etc/ssh/sshd_config',
    line   => 'PermitRootLogin no',
    match  => '^PermitRootLogin\ ',
  }

  # Ensure PermitEmptyPasswords is Disabled - Section 5.3.11
  file_line { 'set_emptypasswords_off':
    ensure => 'present',
    path   => '/etc/ssh/sshd_config',
    line   => 'PermitEmptyPasswords no',
    match  => '^PermitEmptyPasswords\ ',
  }

  # Ensure SSH PermitUserEnvironment is Disabled - Section 5.3.12
  file_line { 'set_permituserenv_off':
    ensure => 'present',
    path   => '/etc/ssh/sshd_config',
    line   => 'PermitUserEnvironment no',
    match  => '^PermitUserEnvironment\ ',
  }

  # Ensure only strong ciphers are used - Section 5.3.13
  file_line { 'set_ssh_ciphers':
    ensure => 'present',
    path   => '/etc/ssh/sshd_config',
    line   => 'Ciphers chacha20-poly1305@openssh.com,aes256-gcm@openssh.com,aes128-gcm@openssh.com,aes256-ctr,aes192-ctr,aes128-ctr',
    match  => '^Ciphers\ ',
  }

  # Ensure only strong MAC algorithms are used - Section 5.3.14
  file_line { 'set_ssh_macs':
    ensure => 'present',
    path   => '/etc/ssh/sshd_config',
    line   => 'MACs hmac-sha2-512-etm@openssh.com,hmac-sha2-256-etm@openssh.com,hmac-sha2-512,hmac-sha2-256',
    match  => '^MACs\ ',
  }

  # Ensure only strong Key Exchange algorithms are used - Section 5.3.15
  file_line { 'ssh_keyexchange_algos':
    ensure => 'present',
    path   => '/etc/ssh/sshd_config',
    line   => 'KexAlgorithms curve25519-sha256,curve25519-sha256@libssh.org,diffie-hellman-group14-sha256,diffie-hellman-group16-sha512,diffie-hellman-group18-sha512,ecdh-sha2-nistp521,ecdh-sha2-nistp384,ecdh-sha2-nistp256,diffie-hellman-group-exchange-sha256',
    match  => '^KexAlgorithms\ ',
  }

  # Ensure SSH Idle Timeout Interval is configured - Section 5.3.16
  file_line { 'client_alive_interval':
    ensure => 'present',
    path   => '/etc/ssh/sshd_config',
    line   => 'ClientAliveInterval 300',
    match  => '^ClientAliveInterval\ ',
  }

  # Ensure SSH LoginGraceTime is set to One Minute or Less - Section 5.3.17
  file_line { 'login_grace_time':
    ensure => 'present',
    path   => '/etc/ssh/sshd_config',
    line   => 'LoginGraceTime 60',
    match  => '^LoginGraceTime\ ',
  }

  # Ensure SSH Warning Banner is Configured - Section 5.3.18
  file_line { 'set_ssh_banner':
    ensure => 'present',
    path   => '/etc/ssh/sshd_config',
    line   => 'Banner /etc/issue.net',
    match  => '^Banner\ ',
  }

  # Ensure SSH PAM is enabled - Section 5.3.19
  file_line { 'set_ssh_pam':
    ensure => 'present',
    path   => '/etc/ssh/sshd_config',
    line   => 'UsePAM yes',
    match  => '^UsePAM\ ',
  }

  # Ensure SSH AllowTcpForwarding is disabled - Section 5.3.20
  file_line { 'ssh_allowtcpforwarding':
    ensure => 'present',
    path   => '/etc/ssh/sshd_config',
    line   => 'allowtcpforwarding no',
    match  => '^allowtcpforwarding\ ',
  }

  # Ensure SSH MaxStartups is configured - Section 5.3.21
  file_line { 'ssh_maxstartups':
    ensure => 'present',
    path   => '/etc/ssh/sshd_config',
    line   => 'maxstartups 10:30:60',
    match  => '^maxstartups\ ',
  }

  # Ensure SSH MaxSessions is limited - Section 5.3.22
  file_line { 'ssh_maxsessions':
    ensure => 'present',
    path   => '/etc/ssh/sshd_config',
    line   => 'maxsessions 10',
    match  => '^maxsessions\ ',
  }

}
