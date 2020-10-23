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

  # Ensure permissions on SSH private host key files are configured - Section 5.2.2
  exec { 'set_sshprivkey_perms':
    path    => '/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin',
    command => "find /etc/ssh -xdev -type f -name 'ssh_host_*_key' -exec chmod u-x,g-wx,o-rwx {} \;",
  }

  exec { 'set_sshprivkey_owner':
    path    => '/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin',
    command => "find /etc/ssh -xdev -type f -name 'ssh_host_*_key' -exec chown root:ssh_keys {} \;",
  }

  # Ensure permissions on SSH public host key files are configured - Section 5.2.3
  exec { 'set_sshpubkey_perms':
    path    => '/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin',
    command => "find /etc/ssh -xdev -type f -name 'ssh_host_*_key.pub' -exec chmod u-x,go-wx {} \;",
  }

  exec { 'set_sshpubkey_owner':
    path    => '/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin',
    command => "find /etc/ssh -xdev -type f -name 'ssh_host_*_key.pub' -exec chown root:root {} \;",
  }

  # Ensure SSH access is limited - Section 5.2.4
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

  # Ensure SSH LogLevel is appropriate - Section 5.2.5
  file_line { 'set_ssh_loglevel':
    ensure => 'present',
    path   => '/etc/ssh/sshd_config',
    line   => 'LogLevel INFO',
  }
    
  # Ensure SSH X11 Forwarding is disabled - Section 5.2.6
  file_line { 'set_x11_forwarding':
    ensure => 'present',
    path   => '/etc/ssh/sshd_config',
    line   => 'X11Forwarding no',
  }

  # Ensure SSH MaxAuthTries is set to 4 or less - Section 5.2.7
  file_line { 'set_ssh_maxauthtries':
    ensure => 'present',
    path   => '/etc/ssh/sshd_config',
    line   => 'MaxAuthTries 4',
  }
    
  # Ensure SSH IgnoreRhosts is enabled - Section 5.2.8
  file_line { 'set_ssh_ignore_rhosts':
    ensure => 'present',
    path   => '/etc/ssh/sshd_config',
    line   => 'IgnoreRhosts yes',
  }

  # Ensure SSH HostBased Authentication is Disabled - Section 5.2.9
  file_line { 'set_hostbasedauth_off':
    ensure => 'present',
    path   => '/etc/ssh/sshd_config',
    line   => 'HostBasedAuthentication no',
  }

  # Ensure SSH Root Login is Disabled - Section 5.2.10
  file_line { 'set_rootlogin_no':
    ensure => 'present',
    path   => '/etc/ssh/sshd_config',
    line   => 'PermitRootLogin no',
  }

  # Ensure PermitEmptyPasswords is Disabled - Section 5.2.11
  file_line { 'set_emptypasswords_off':
    ensure => 'present',
    path   => '/etc/ssh/sshd_config',
    line   => 'PermitEmptyPasswords no',
  }

  # Ensure SSH PermitUserEnvironment is Disabled - Section 5.2.12
  file_line { 'set_permituserenv_off':
    ensure => 'present',
    path   => '/etc/ssh/sshd_config',
    line   => 'PermitUserEnvironment no',
  }


  # Ensure only strong ciphers are used - Section 5.2.13
  file_line { 'set_ssh_ciphers':
    ensure => 'present',
    path   => '/etc/ssh/sshd_config',
    line   => 'Ciphers chacha20-poly1305@openssh.com,aes256-gcm@openssh.com,aes128-gcm@openssh.com,aes256-ctr,aes192-ctr,aes128-ctr',
    match  => '^Ciphers\ ',
  }

  # Ensure only strong MAC algorithms are used - Section 4.2.14
  file_line { 'set_ssh_macs':
    ensure => 'present',
    path   => '/etc/ssh/sshd_config',
    line   => 'MACs hmac-sha2-512-etm@openssh.com,hmac-sha2-256-etm@openssh.com,hmac-sha2-512,hmac-sha2-256',
    match  => '^MACs\ ',
  }

  # Ensure only strong Key Exchange algorithms are used - Section 5.2.15
  file_line { 'ssh_keyexchange_algos':
    ensure => 'present',
    path   => '/etc/ssh/sshd_config',
    line   => 'KeyxAlgorithms curve25519-sha256,curve25519-sha256@libssh.org,diffie-helman-group14-sha256,diffie-helman-group16-sha512,diffie-hellman-group18-sha512,ecdh-sha2-nistp521,ecdh-sha2-nistp384,ecdh-sha2-nistp256,diffie-helman-group-exchange-sha256',
    match  => '^KeyxAlgorithms\ ',
  }

  # Ensure SSH Idle Timeout Interval is configured - Section 5.2.16
  file_line { 'client_alive_interval':
    ensure => 'present',
    path   => '/etc/ssh/sshd_config',
    line   => 'ClientAliveInterval 300',
  }

  # Ensure SSH LoginGraceTime is set to One Minute or Less - Section 5.2.17
  file_line { 'login_grace_time':
    ensure => 'present',
    path   => '/etc/ssh/sshd_config',
    line   => 'LoginGraceTime 60',
    match  => '^LoginGraceTime',
  }

  # Ensure SSH Warning Banner is Configured - Section 5.2.18
  file_line { 'set_ssh_banner':
    ensure => 'present',
    path   => '/etc/ssh/sshd_config',
    line   => 'Banner /etc/issue.net',
    match  => '^Banner\ ',
  }

  # Ensure SSH PAM is enabled - Section 5.2.19
  file_line { 'set_ssh_pam':
    ensure => 'present',
    path   => '/etc/ssh/sshd_config',
    line   => 'UsePAM yes',
    match  => '^UsePAM\ ',
  }

  # Ensure SSH AllowTcpForwarding is disabled - Section 5.2.20
  file_line { 'ssh_allowtcpforwarding':
    ensure => 'present',
    path   => 
  }


  # Set sshd_config Options - Section 5.2.2
  file_line { 'set_ssh_protocol':
    ensure => 'present',
    path   => '/etc/ssh/sshd_config',
    line   => 'Protocol 2',
  }

  

  file_line { 'client_alive_count_max':
    ensure => 'present',
    path   => '/etc/ssh/sshd_config',
    line   => 'ClientAliveCountMax 0',
  }



  

}
