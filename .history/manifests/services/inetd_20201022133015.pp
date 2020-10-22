# @summary A manifest to configure inetd services according to CIS
# hardening guidelines
#
# Section 2.1 - InetD Services
#
# @example
#   include cis_hardening::services::inetd
class cis_hardening::services::inetd {

  # Esure XinetD is not installed - Section 2.1.1
  package { 'xinetd':
    ensure => 'absent',
  }

  


}
