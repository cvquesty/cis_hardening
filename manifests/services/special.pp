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

  # NOTE: If chrony is preferred, uncomment chrony stanzas and comment NTP stanzas
  #package{ 'chrony':
  #  ensure => 'present',
  #}

  # Ensure Chrony is configured - Section 2.2.1.2
  #file { '/etc/chrony.conf':
  #  ensure => 'present',
  #  owner  => 'root',
  #  group  => 'root',
  #  mode   => '0644',
  #  source => 'puppet:///modules/cis_hardening/etc_chrony_conf',
  #}

  #file_line { 'chrony_settings':
  #  ensure => 'present',
  #  path   => '/etc/sysconfig/chronyd',
  #  line   => 'OPTIONS="-u chrony"',
  #  match  => '^OPTIONS="-u"',
  #}

  # Ensure ntp is configured - Section 2.2.1.3
  file { '/etc/ntp.conf':
    ensure  => 'file',
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    source  => 'puppet:///modules/cis_hardening/etc_ntp_conf',
    require => Package['ntp'],
  }

  file { '/etc/sysconfig/ntpd':
    ensure  => 'file',
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

  # Ensure DNS Server is not installed - Section 2.2.7
  package { 'bind':
    ensure => 'absent',
  }

  # Ensure FTP Server is not installed - Section 2.2.8
  package { 'vsftpd':
    ensure => 'absent',
  }

  # Ensure HTTP Server is not installed - Section 2.2.9
  package { 'httpd':
    ensure => 'absent',
  }

  # Ensure IMAP and POP3 Server are not installed - Section 2.2.10
  package { 'dovecot':
    ensure => 'absent',
  }

  # Ensure Samba is not installed - Section 2.2.11
  package { 'samba':
    ensure => 'absent',
  }

  # Ensure HTTP Proxy Server is not installed - Section 2.2.12
  package { 'squid':
    ensure => 'absent',
  }

  # Ensure net-snmp Server is not installed - Section 2.2.13
  package { 'net-snmp':
    ensure => 'absent',
  }

  # Ensure NIS Server is not installed - Section 2.2.14
  package { 'ypserv':
    ensure => 'absent',
  }

  # Ensure Telnet Server is not installed - Section 2.2.15
  package { 'telnet-server':
    ensure => 'absent',
  }

  # Ensure MTA is configured for local-only mode - Section 2.2.16
  file_line { 'smptp_local_only_mode':
    ensure => 'present',
    path   => '/etc/postfix/main.cf',
    line   => 'inet_interfaces = loopback-only',
    match  => '^inet_interfaces\ =',
    notify => Service['postfix'],
  }

  service { 'postfix':
    ensure => 'running',
    enable => true,
  }

  # Ensure nfs-utils is not installed or the nfs-server service is masked - Section 2.2.17
  package { 'nfs-utils':
    ensure => 'absent',
  }

  # Ensure rpcbind is not installed or the rpcbind services are masked - Section 2.2.18
  package { 'rpcbind':
    ensure => 'absent',
  }

  # Ensure Rsync Service is not installed - Section 2.2.19
  package { 'rsync':
    ensure => 'absent',
  }
}
