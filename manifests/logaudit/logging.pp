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
  # Ensure rsyslog is installed - Section 4.2.1.1
  package { 'rsyslog':
    ensure => 'present',
  }

  # Ensure rsyslog service is enabled and running - Section 4.2.1.2
  service { 'rsyslog':
    ensure     => 'running',
    enable     => true,
    hasstatus  => true,
    hasrestart => true,
    require    => Package['rsyslog'],
  }

  # Ensure rsyslog default file permissions configured - Section 4.2.1.3
  file_line { 'logfile_perms':
    ensure => 'present',
    path   => '/etc/rsyslog.conf',
    line   => '$FileCreateMode 0640',
  }

  # Ensure logging is configured - Section 4.2.1.4
  # Manual step for configuring Rsyslog
  #
  # TODO: automate process of configuring rsyslog

  # Ensure rsyslog is configured to send logs to a remote log host - Section 4.2.1.5
  # file_line { 'remote_loghost':
  #  ensure => 'present',
  #  path   => '/etc/rsyslog.conf',
  #  line   => '*.* @@loghost.example.com',
  #}
  #
  # NOTE: Uncomment above and populate "line" attribute with appropriate syslog server.

  # Ensure remote rsyslog messages are only accepted on designated log hosts - Section 4.2.1.6
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



  # If using syslog-ng:
  # package { 'syslog-ng':
  #   ensure => 'present',
  # }

  # Ensure permissions on all logfiles are configured - Section 4.2.3
  exec { 'set_logfile_permissions':
    path    => '/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin',
    command => 'find /var/log -type f -exec chmod g-wx,o-rwx "{}" +',
  }

  # Ensure logrotate is configured - Section 4.2.4
  #
  # NOTE: LogRotate will be different per site and the needs of the security department will
  # dictate what and how these are to be configured. I recommend using the puppet-logrotate
  # module from the Puppet Forge, and instrumenting it with Hiera + a profile to be applied
  # to systems that need their logs rotated.

}
