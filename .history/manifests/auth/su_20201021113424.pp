# @summary A manifest to implement su rules according to CIS hardening guidelines
#
# Section 5.6
#
# @example
#   include cis_hardening::auth::su
class cis_hardening::auth::su {
    # Ensure access to the su command is restricted - Section 5.6

    # Part 1 - Specify a group explicitly for use with su:
    group { 'sugroup':
      ensure => 'present',
    }

  # Part 2 - enter the su setting into /etc/pam.d/su and tie it to the group
  # created in Part 1 above
  file { '/etc/pam.d/su':
    path => '/etc/pam.d/su',
    line => 'auth required pam_wheel.so use_uid group=sugroup',
  }
}
