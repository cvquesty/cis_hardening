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
  exec { 'pass_max_days':
    path    => '/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin',
    command => "perl -pi -e 's/^PASS_MAX_DAYS.*$/PASS_MAX_DAYS 365/' /etc/login.defs",
    unless  => "test ! `grep ^PASS_MAX_DAYS /etc/login.defs |awk '{print \$2}'` -gt 365",
  }

  # Ensure minimum days between password changes is 7 or more - Section 5.4.1.2
  exec { 'pass_min_days':
    path    => '/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin',
    command => "perl -pi -e 's/^PASS_MIN_DAYS.*$/PASS_MIN_DAYS 7/' /etc/login.defs",
    onlyif  => "test ! `grep ^PASS_MIN_DAYS /etc/login.defs |awk '{print \$2}'` -gt 7",
  }

  # Ensure Pasword Expiration warning days is 7 or more - Section 5.4.1.3
  exec { 'pass_warn_age':
    path    => '/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin',
    command => "perl -pi -e 's/PASS_WARN_AGE.*$/PASS_WARN_AGE 7/' /etc/login.defs",
    onlyif  => "test ! `grep ^PASS_WARN_AGE /etc/login.defs |awk '{print \$2}'` -lt 7",
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
  exec { 'set_login_umask_etcprofile':
    path    => '/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin',
    command => 'echo "umask 027" >> /etc/profile',
    onlyif  => 'test ! `grep umask |grep 027 /etc/profile`',
    unless  => 'test `grep umask /etc/profile`',
  }

  exec { 'set_login_umask_etcbashrc':
    path    => '/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin',
    command => "perl -pi -e 's/umask.*$/umask 027/' /etc/bashrc",
    unless  => 'test `grep umask /etc/bashrc`',
  }

  # Ensure default user shell tieout is 900 seconds or less - Section 5.4.5
  exec { 'set_user_timeout_etcprofile':
    path    => '/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin',
    command => 'echo TMOUT=600 >> /etc/profile',
    onlyif  => 'test ! `grep ^TMOUT /etc/profile`',
    unless  => 'test `grep ^TMOUT /etc/profile`',
  }

  exec { 'set_user_timeout_etcbashrc':
    path    => '/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin',
    command => 'echo "TMOUT=600" >> /etc/bashrc',
    onlyif  => 'test ! `grep TMOUT /etc/bashrc`',
    unless  => "test `grep TMOUT /etc/bashrc |awk -F '=' '{print \$2}'` -ne 600",
  }

  # Ensure root login is restricted to system console - Section 5.5
  # Given this is AWS, the physical console is unavailable. This
  # cannot occur in a virtualized environment the way this rule is intended.
}
