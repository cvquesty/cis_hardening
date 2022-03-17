# @summary A manifest to configure system warning banners according to policy in line with CIS hardening
# guidelines
#
# Section 1.7 - Command Line Warning Banners
#
# @example
#   include cis_hardening::setup::banners
class cis_hardening::setup::banners {

  # Ensure message of the day is configured properly - Section 1.7.1
  # Ensure permisisons on /etc/motd are configured - Section 1.7.4
  file { '/etc/motd':
    ensure => 'present',
    owner  => 'root',
    group  => 'root',
    mode   => '0644',
    source => 'puppet:///modules/cis_hardening/etc_motd',
  }

  # Ensure local login warning banner is configured properly - Section 1.7.2
  # Ensure permissions on /etc/issue are configured - Section 1.7.5
  file { '/etc/issue':
    ensure => 'present',
    owner  => 'root',
    group  => 'root',
    mode   => '0644',
    source => 'puppet:///modules/cis_hardening/etc_issue',
  }

  # Ensure remote login warning banner is configured properly - Section 1.7.3
  # Ensure permissions on /etc/issue.net are configured - Section 1.7.6
  file { '/etc/issue.net':
    ensure => 'present',
    owner  => 'root',
    group  => 'root',
    mode   => '0644',
    source => 'puppet:///modules/cis_hardening/etc_issue_net',
  }

  # Ensure updates, patches, and additional security software are installed - Section 1.9
  exec { 'check_for_updates':
    path    => '/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin',
    command => 'logger -p crit "Updates to the system are available."',
    onlyif  => 'test ! `yum check-update`',
  }

  # Section 1.8 - Gnome Display Manager

  # Check that GDM is configured  - Section 1.8.1
  # Ensure GDM Login banner is configured - Section 1.8.2
  #
  # NOTE: If GDM is intended to be on, the local fact will need to be set in <moduledir>/facts.d/gdm
  #
  if $facts['gdm'] == 'present' {
    # Ensure GDM login banner is configured
    file_line { 'gdm_userdb':
      ensure => 'present',
      path   => '/etc/dconf/profile/gdm',
      line   => 'user-db:user',
    }

    file_line { 'gdm_systemdb':
      ensure => 'present',
      path   => '/etc/dconf/profile/gdm',
      line   => 'system-db:gdm',
    }

    file_line { 'gdm_filedb':
      ensure => 'present',
      path   => '/etc/dconf/profile/gdm',
      line   => 'file-db:/usr/share/gdm/greeter-dconf-defaults',
    }

    file_line { 'gdm_banner_loginscreenenable':
      ensure => 'present',
      path   => '/etc/dconf/db/gdm.d/01-banner-message',
      line   => '[org/gnome/login-screen]',
      notify => Exec['refresh_dconf'],
    }

    file_line { 'gdm_banner_message_enable':
      ensure => 'present',
      path   => '/etc/dconf/db/gdm.d/01-banner-message',
      line   => 'banner-message-enable=true',
      notify => Exec['refresh_dconf'],
    }

    file_line { 'gdm_banner_message_text':
      ensure => 'present',
      path   => '/etc/dconf/db/gdm.d/01-banner-message',
      line   => "banner-message-text='Secure Login'",
      notify => Exec['refresh_dconf'],
    }

    # Ensure last logged in user display is disabled - Section 1.8.3
    file_line { 'gdm_lastlogin_list_disable':
      ensure => 'present',
      path   => '/etc/dconf/db/gdm.d/00-login-screen',
      line   => 'disable-user-list=true',
      notify => Exec['refresh_dconf'],
    }

    # Ensure XDCMP Not Enabled - Section 1.8.4
    file_line { 'xdcmp_disable':
      ensure => 'present',
      path   => '/etc/gdm/custom.conf',
      match  => '^Enable=true',
      line   => 'Enable=false',
      notify => Exec['refresh_dconf'],
    }

    # Refresh dconf
    exec { 'refresh_dconf':
      path    => '/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin',
      command => 'dconf update',
    }
  }
}
