# @summary A manifest to configure special services according to 
# CIS Hardening Guidelines
#
# Section 2.2 - Special Purpose Services
#
# @example
#   include cis_hardening::services::special
class cis_hardening::services::special {

  # 2.2.1 - Time Synchronization
  # Ensure time synchronization is in use - Section 2.2.1.1
  package { 'ntp':
    ensure => 'present',
  }

  package{ 'chrony':
    ensure => 'present',
  }

  # Ensure Chrony is configured - Section 2.2.1.2
  file { '/etc/chrony.conf':
    ensure => 'present',
    owner  => 'root',
    group  => 'root',
    mode   => '0644',
    source => 'puppet:///modules/cis_hardening/etc_chrony_conf',
  }

  file_line { 'chrony_settings':
    ensure => 'present',
    path   => '/etc/sysconfig/chronyd',
    line   => 'OPTIONS="-u chrony"',
    match  => '^OPTIONS="-u"',
  }

  # Ensure ntp is configured - Section 2.2.1.3
  file { '/etc/ntp.conf':
    ensure  => 'present',
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    source  => 'puppet:///modules/cis_hardening/etc_ntp_conf',
    require => Package['ntp'],
  }

  file { '/etc/sysconfig/ntpd':
    ensure  => 'present',
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    source  => 'puppet:///modules/cis_hardening/etc_sysconfig_ntpd',
    require => File['/etc/ntp.conf'],
  }

  file_line { 'ntp_options':
    ensure => 'present',
    path   => '/usr/lib/systemd/system/ntpd.service',
    line   => 'ExecStart=/usr/sbin/ntpd -u ntp:ntp $OPTIONS',
    match  => '^ExecStart=/usr/sbin/ntpd -u ntp:ntp $OPTIONS',
  }

  # Ensure X Window System is not installed - Section 2.2.2
  package { 'xorg-x11-server-Xorg':
    ensure => 'absent',
  }

  # Ensure Avahi Server is not installed - Section 2.2.3
  package { 'avahi':
    ensure => 'absent',
  }

  package { 'avahi-autoipd':
    ensure => 'absent',
  }

  # Ensure CUPS is not installed - Section 2.2.4
  package { 'cups':
    ensure => 'absent',
  }

  # Ensure DHCP Server is not installed - Section 2.2.5
  package { 'dhcp':
    ensure => 'absent',
  }

  # Ensure LDAP Server is not installed - Section 2.2.6
  package { 'openldap-servers':
    ensure => 'absent',
  }

  # Ensure nfs-utils is not installed or the nfs-server service is masked - Section 2.2.7
  package { ''}
  
  # Ensure NFS and RPC are not enabled - Section 2.2.7
  service { 'nfs':
    enable => false,
  }

  service { 'nfs-server':
    enable => false,
  }

  service { 'rpcbind':
    enable => false,
  }

  # Ensure DNS Server is not enabled - Section 2.2.8
  service { 'named':
    enable => false,
  }

  # Ensure FTP Server is not enabled - Section 2.2.9
  service { 'vsftpd':
    enable => false,
  }

  # Ensure HTTP Server is not enabled - Section 2.2.10
  service { 'httpd':
    enable => false,
  }

  # Ensure IMAP and POP3 Server are not enabled - Section 2.2.11
  service { 'dovecot':
    enable => false,
  }

  # Ensure Samba is not enabled - Section 2.2.12
  service { 'smb':
    enable => false,
  }

  # Ensure HTTP Proxy Server is not enabled - Section 2.2.13
  service { 'squid':
    enable => false,
  }

  # Ensure SNMP Server is not enabled - Section 2.2.14
  service { 'snmpd':
    enable => false,
  }

  # Ensure MTA is configured for local-only mode - Section 2.2.15
  file_line { 'smptp_local_only_mode':
    ensure => 'present',
    path   => '/etc/postfix/main.cf',
    line   => 'inet_interfaces = loopback-only',
    match  => '^inet_interfaces\ =',
  }

  # Ensure NIS Server is not enabled - Section 2.2.16
  service { 'ypserv':
    enable => false,
  }

  # Ensure RSH Server is not enabled - Section 2.2.17
  service { 'rsh.socket':
    enable => false,
  }

  service { 'rlogin.socket':
    enable => false,
  }

  service { 'rexec.socket':
    enable => false,
  }

  # Ensure Telnet Server is not enabled - Section 2.2.18
  service { 'telnet.socket':
    enable => false,
  }

  # Ensure tftp Server is not enabled - Section 2.2.19
  service { 'tftp.socket':
    enable => false,
  }

  # Ensure Rsync Service is not enabled - Section 2.2.20
  service { 'rsyncd':
    enable => false,
  }

  # Ensure Talk server is not enabled - Section 2.2.21
  service { 'ntalk':
    enable => false,
  }
}
