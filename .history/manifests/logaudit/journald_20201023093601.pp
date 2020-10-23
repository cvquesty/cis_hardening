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
  } 

  # Ensure journald is configured to compress large log files - 

}
