# @summary A manifest to configuring the logging subsystem according to CIS 
# hardening guidelines
#
# Section 4.2 - Configure Logging
#
# @example
#   include cis_hardening::logaudit::logging
class cis_hardening::logaudit::logging {

  # Configure rsyslog - Section 4.2.1
  #
  # Ensure rsyslog service is enabled - Section 4.2.1.1
  service { 'rsyslog':
    ensure     => 'running',
    enable     => true,
    hasstatus  => true,
    hasrestart => true,
    require    => Package['rsyslog'],
  }

  # Ensure logging is configured - Section 4.2.1.2
  # Default logging setup covers all suggested filters in rsyslog for RHEL/CentOS 7

  # Ensre rsyslog default file permissions configured - Section 4.2.1.3
  file_line { 'logfile_perms':
    ensure => 'present',
    path   => '/etc/rsyslog.conf',
    line   => '$FileCreateMode 0640',
  }

  # Ensure rsyslog is configured to send logs to a remote log host - Section 4.2.1.4
  # file_line { 'remote_loghost':
  #  ensure => 'present',
  #  path   => '/etc/rsyslog.conf',
  #  line   => '*.* @@loghost.example.com',
  #}
  # 
  # NOTE: Uncomment above and populate "line" attribute with appropriate syslog server.

  # Ensure remote rsyslog messages are only accepted on designated log hosts - Section 4.2.1.5
  # add imtcp setting
  #file_line { 'imtcp_log':
  #  ensure => 'present',
  #  path   => '/etc/rsyslog.conf',
  #  line   => '$ModLoad imtcp',
  #}

  # Add in port for logging
  #file_line { 'logport':
  #  ensure => 'present',
  #  path   => '/etc/rsyslog.conf',
  #  line   => '$INPUTTCPSERVERRUN 514',
  #}
  #
  # NOTE: Should you be managing a SysLog server/Loghost, the above is an example as to the lines
  # needed to meet security requirements on the loghost. Apply the above to that loghost. This might
  # require a separate manifest to include just those lines, and apply it to a profile designated
  # to loghosts.

  # Section 4.2.2 - Configure syslog-ng
  #
  #  Sections 4.2.2.1, 4.2.2.2, 4.2.2.3, 4.2.2.4, 4.2.2.5 are all covered by this section.
  #
  # NOTE: syslog-ng is not selected in favor of rsyslog, so this section does not apply if the above
  # section is used. They are mutually exclusive.

  # Ensure rsyslog (or syslog-ng) is installed - Section 4.2.3
  package { 'rsyslog':
    ensure => 'present',
  }

  # If using syslog-ng:
  # package { 'syslog-ng':
  #   ensure => 'present',
  # }

  # Ensure permissions on all logfiles are configured - Section 4.2.4
  exec { 'set_logfile_permissions':
    path    => '/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin',
    command => 'find /var/log -type f -exec chmod g-wx,o-rwx {} +',
  }
}
