# @summary A manifest to configure LogRotate on the server
#
# Section 4.3
#
# @example
#   include cis_hardening::logaudit::logrotate
class cis_hardening::logaudit::logrotate {

  # LogRotate will be different per site and the needs of the security department will
  # dictate what and how these are to be configured. I recommend using the puppet-logrotate
  # module from the Puppet Forge, and instrumenting it with Hiera + a profile to be applied
  # to systems that need their logs rotated.

}
