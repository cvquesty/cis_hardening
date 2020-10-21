# @summary A manifest to implement su rules according to CIS hardening guidelines
#
# Section 5.6
#
# @example
#   include cis_hardening::auth::su
class cis_hardening::auth::su {
    # Ensure access to the su command is restricted - Section 5.6
  file_line { 'su_setting':
    path => '/etc/pam.d/su',
    line => 'auth required pam_wheel.so use_uid',
  }
}
