# @summary A manifest to configure the PAM subsystem according to CIS
# hardening guidelines
#
# Section 5.3
#
# Hardens PAM in line with CIS standards for CentOS 7.x Servers
class cis_hardening::auth::pam {

  # Ensure Password creation requirements are configured - Section 5.3.1
  file { '/etc/security/pwquality.conf':
    ensure => 'present',
    owner  => 'root',
    group  => 'root',
    mode   => '0644',
    source => 'puppet:///modules/cis_hardening/pwquality.conf',
  }

  # Ensure lockout delay for failed password attempts is configured - Section 5.3.2
  exec { 'enable_lockout_delay_sysauthac':
    path    => '/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin',
    command => "perl -i -e 's/pam_faildelay.so.*$/pam_faildelay.so delay=2000000/' /etc/pam.d/system-auth-ac",
    unless  => "grep 'delay=2000000' /etc/pam.d/system-auth-ac",
  }

  exec { 'enable_lockout_delay_passauthac':
    path    => '/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin',
    command => "perl -i -e 's/pam_faildelay.so.*$/pam_faildelay.so delay=2000000/' /etc/pam.d/password-auth-ac",
    unless  => "grep 'delay=2000000' /etc/pam.d/password-auth-ac",
  }

  # Ensure Password Reuse is Limited - Section 5.3.3
  exec { 'limit_pw_reuse_sysauthac':
    path    => '/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin',
    command => "perl -pi -e 's/$/ remember=5/ if /^password\s+sufficient\s+pam_unix.so/' /etc/pam.d/system-auth-ac",
    unless  => "grep 'remember=5' /etc/pam.d/system-auth-ac",
  }

  exec { 'limit_pw_reuse_passauthac':
    path    => '/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin',
    command => "perl -pi -e 's/$/ remember=5/ if /^password\s+sufficient\s+pam_unix.so/' /etc/pam.d/password-auth-ac",
    unless  => "grep 'remember=5' /etc/pam.d/password-auth-ac",
  }

  # Ensure Password Hashing Algorithm is SHA-512 - Section 5.3.4
  exec { 'set_pw_hashing_algo_sysauthac':
    path    => '/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin',
    command => "perl -pi -e 's/$/ sha512/ if /^password\s+sufficient\s+pam_unix.so/' /etc/pam.d/system-auth-ac",
    unless  => 'grep sha512 /etc/pam.d/system-auth-ac',
  }

  exec { 'set_pw_hashing_algo_passauthac':
    path    => '/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin',
    command => "perl -pi -e 's/$/ sha512/ if /^password\s+sufficient\s+pam_unix.so/' /etc/pam.d/password-auth-ac",
    unless  => 'grep sha512 /etc/pam.d/password-auth-ac',
  }
}
