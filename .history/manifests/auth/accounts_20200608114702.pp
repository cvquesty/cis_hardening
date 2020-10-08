# @summary A manifest to configure system and user accounts according to
# CIS hardening Guidelines
#
# Section 5.4
#
# @example
#   include cis_hardening::auth::accounts
class cis_hardening::auth::accounts {

  # This is very near the entry point. I use perl quite a bit, so installing it here
  package { 'perl':
    ensure => 'present',
  }

  # Set Shadow Password Suite Parameters - Section 5.4.1

  # Ensure Password expiration is 365 days or less - Section 5.4.1.1
  file_line { 'pass_max_days':
    ensure => 'present',
    path   => '/etc/login.defs',
    line   => 'PASS_MAX_DAYS 365',
    match  => '^PASS_MAX_DAYS\ ',
  }

  # Ensure minimum days between password changes is 7 or more - Section 5.4.1.2
  file_line { 'pass_min_days':
    ensure => 'present',
    path   => '/etc/login.defs',
    line   => 'PASS_MIN_DAYS 7',
    match  => '^PASS_MIN_DAYS\ ',
  }

  # Ensure Pasword Expiration warning days is 7 or more - Section 5.4.1.3
  file_line { 'pass_warn_age':
    ensure => 'present',
    path   => '/etc/login.defs',
    line   => 'PASS_WARN_AGE 7',
    match  => '^PASS_WARN_AGE\ ',
  }

  # Ensure inactive password lock is 30 days or less - Section 5.4.1.4
  # Note: This setting and remediation is a checking of state of individual users
  # on an ongoing basis. It's difficult to run this as an exec due to idempotency
  # issues. I would recommend a Bolt task for this, but we're not using Bolt for this
  # project. This would be an ad-hoc task or a choice to accept the risk associated.

  # Ensure all users last password change date is in the past - Section 5.4.1.5
  # Similar to the above, this is a manual check that cannot be automated. The output cannot
  # "fire" any actiions. Another risk acceptance and/or ad-hoc task.

  # Ensure System Accounts are non-login - Section 5.4.2
  # Another ad-hoc check with no system utility or automation similar to the above two.

  # Ensure default group for the root account is GID 0 - Section 5.4.3
  user { 'root':
    ensure => 'present',
    gid    => 'root',
  }

  # Ensure default user umask is 027 or more restrictive - Section 5.4.4
  file { '/etc/profile.d/cisumaskprofile.sh':
    ensure  => 'present',
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    content => 'umask 027',
  }

  file { '/etc/profile.d/cisumaskbashrc.sh':
    ensure  => 'present',
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    content => 'umask 027',
  }

  # Ensure default user shell tieout is 900 seconds or less - Section 5.4.5
  file_line { 'set_user_timeout_etcprofile':
    ensure  => 'present',
    path    => '/etc/profile.d/cisumaskprofile.sh',
    line    => 'TMOUT=600',
    match   => '^TMOUT\=',
    require => File['/etc/profile.d/cisumaskprofile.sh']
  }

  file_line { 'set_user_timeout_etcbashrc':
    ensure => 'present',
    path   => '/etc/bashrc',
    line   => 'TMOUT=600',
    match  => '^TMOUT\=',
  }
  # Ensure root login is restricted to system console - Section 5.5
  # Given this is AWS, the physical console is unavailable. This
  # cannot occur in a virtualized environment the way this rule is intended.
}
