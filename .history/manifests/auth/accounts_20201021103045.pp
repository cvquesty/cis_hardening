# @summary A manifest to configure system and user accounts according to
# CIS hardening Guidelines
#
# Section 5.4 - User Accounts and Environment
#
# @example
#   include cis_hardening::auth::accounts
class cis_hardening::auth::accounts {

  # This is very near the entry point. cis_hardening uses perl quite a bit, so installing it here
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

  # Ensure minimum days between password changes is no less than one day - Section 5.4.1.2
  file_line { 'pass_min_days':
    ensure => 'present',
    path   => '/etc/login.defs',
    line   => 'PASS_MIN_DAYS 1',
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
  file_line { 'dormant_lock':
    ensure => 'present',
    path   => '/etc/defaults/useradd',
    line   => 'INACTIVE=30',
    match  => '^INACTIVE\=',
  }

  # Ensure all users last password change date is in the past - Section 5.4.1.5
  # Checks for password change in the future and logs at critical to syslog.
  exec { 'password_change_past':
    path    => '/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin',
    command => 'logger -p crit "Password Change date in past for some users."',
    onlyif  => 'test ! "for usr in $(cut -d: -f1 /etc/shadow); do [[ $(chage --list $usr | grep '^Last password change' | cut -d: -f2) > $(date) ]] && echo "$usr :$(chage -- list $usr | grep '^Last password change' | cut -d: -f2)"; done"',
  }

  # Ensure System Accounts are non-login - Section 5.4.2
  # Two checks below to check for login on system accounts, and logs critical to syslog
  # if present.
  exec { 'sys_login_shell_check_logindefs':
    path    => '/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin',
    command => 'logger -p crit "Logindefs allows shell for system accounts."',
    onlyif  => 'test ! "awk -F: '($1!="root" && $1!="sync" && $1!="shutdown" && $1!="halt" && $1!~/^\+/ && $3<'"$(awk '/^\s*UID_MIN/{print $2}' /etc/login.defs)"' && $7!="'"$(which nologin)"'" && $7!="/bin/false") {print}' /etc/passwd"',
  }

  exec { 'sys_login_shell_check_passwd':
    path    => '/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin',
    command => 
  }


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
    require => File['/etc/profile.d/cisumaskprofile.sh'],
  }

  file_line { 'set_user_timeout_etcbashrc':
    ensure  => 'present',
    path    => '/etc/profile.d/cisumaskbashrc.sh',
    line    => 'TMOUT=600',
    match   => '^TMOUT\=',
    require => File['/etc/profile.d/cisumaskbashrc.sh'],
  }
  # Ensure root login is restricted to system console - Section 5.5
  # Given this is AWS, the physical console is unavailable. This
  # cannot occur in a virtualized environment the way this rule is intended.
}
