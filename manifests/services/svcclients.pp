# @summary A manifest for hardening services client installations according to CIS Hardening Guidelines
#
# Section 2.3
#
# @example
#   include cis_hardening::services::svcclients
class cis_hardening::services::svcclients {

  # Ensure NIS CLient is not installed - Section 2.3.1
  package { 'ypbind':
    ensure => 'absent',
  }

  # Ensure rsh Client is not installed - Section 2.3.2
  package { 'rsh':
    ensure => 'absent',
  }

  # Ensure talk client is not installed - Section 2.3.3
  package { 'talk':
    ensure => 'absent',
  }

  # Ensure telnet client is not installed - Section 2.3.4
  package { 'telnet':
    ensure => 'absent',
  }

  # Ensure LDAP client is not installed - Section 2.3.5
  package { 'openldap-clients':
    ensure => 'absent',
  }

}
