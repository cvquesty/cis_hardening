# @summary A short summary of the purpose of this class
#
# Section 4.2.2 - Configure journald
#
# @example
#   include cis_hardening::logaudit::journald
class cis_hardening::logaudit::journald {
  # Ensure journald is configured to send logs to rsyslog - Section 4.2.2.1
  file_line { 'journald_to_rsyslog':
    ensure => 'present',
    path   => '/etc/systemd/journald.conf',
    line   => 'ForwardToSyslog=yes',
    match  => '^ForwardToSyslog\=',
  }

  # Ensure journald is configured to compress large log files - Section 4.2.2.2
  file_line { 'journald_compress':
    ensure => 'present',
    path   => '/etc/systemd/journald.conf',
    line   => 'Compress=yes',
    match  => '^Compress\=',
  }

  # Ensure journald is configured to write logfiles to persistent disk - Section 4.2.2.3
  file_line { 'journald_log_persistence':
    ensure => 'present',
    path   => '/etc/systemd/journald.conf',
    line   => 'Storage=persistent',
    match  => '^Storage\=',
  }
}
