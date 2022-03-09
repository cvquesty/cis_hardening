require 'spec_helper'

describe 'cis_hardening::setup::banners' do
  on_supported_os.each do |os, os_facts|
    context "on #{os}" do
      let(:facts) { os_facts }

      # Check for main class
      it {
        is_expected.to contain_class('cis_hardening::setup::banners')
      }

      # Ensure message of the day (MOTD) is properly configured - Section 1.7.1
      # Ensure permisisons on /etc/motd are configured - Section 1.7.4
      it {
        is_expected.to contain_file('/etc/motd').with(
          'ensure' => 'present',
          'owner'  => 'root',
          'group'  => 'root',
          'mode'   => '0644',
          'source' => 'puppet:///modules/cis_hardening/etc_motd',
        )
      }

      # Ensure local login warning banner is configured properly - Section 1.7.2
      # Ensure permissions on /etc/issue are configured - Section 1.7.5
      it {
        is_expected.to contain_file('/etc/issue').with(
          'ensure' => 'present',
          'owner'  => 'root',
          'group'  => 'root',
          'mode'   => '0644',
          'source' => 'puppet:///modules/cis_hardening/etc_issue',
        )
      }

      # Ensure remote login warnig banner is configured properly - Section 1.7.3
      # Ensure permissions on /etc/issue.net are configured - Section 1.7.6
      it {
        is_expected.to contain_file('/etc/issue.net').with(
          'ensure' => 'present',
          'owner'  => 'root',
          'group'  => 'root',
          'mode'   => '0644',
          'source' => 'puppet:///modules/cis_hardening/etc_issue_net',
        )
      }

      # Ensure updates, patches, and additional security software are installed - Section 1.9
      it {
        is_expected.to contain_exec('check_for_updates').with(
          'path'    => '/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin',
          'command' => 'logger -p crit "Updates to the system are available."',
          'onlyif'  => 'test ! `yum check-update`',
        )
      }

      # Check that GDM is configured - Section 1.8.1
      # Ensure GDM login banner is configured - Section 1.8.2
      it {
        is_expected.to contain_file_line('gdm_userdb').with(
          'ensure' => 'present',
          'path'   => '/etc/dconf/profile/gdm',
          'line'   => 'user-db:user',
        )
      }

      it {
        is_expected.to contain_file_line('gdm_systemdb').with(
          'ensure' => 'present',
          'path'   => '/etc/dconf/profile/gdm',
          'line'   => 'system-db:gdm',
        )
      }

      it {
        is_expected.to contain_file_line('gdm_filedb').with(
          'ensure' => 'present',
          'path'   => '/etc/dconf/profile/gdm',
          'line'   => 'file-db:/usr/share/gdm/greeter-dconf-defaults',
        )
      }

      it {
        is_expected.to contain_file_line('gdm_banner_loginscreenenable').with(
          'ensure' => 'present',
          'path'   => '/etc/dconf/db/gdm.d/01-banner-message',
          'line'   => '[org/gnome/login-screen]',
        ).that_notifies('Exec[refresh_dconf]')
      }

      it {
        is_expected.to contain_file_line('gdm_banner_message_enable').with(
          'ensure' => 'present',
          'path'   => '/etc/dconf/db/gdm.d/01-banner-message',
          'line'   => 'banner-message-enable=true',
        ).that_notifies('Exec[refresh_dconf]')
      }

      it {
        is_expected.to contain_file_line('gdm_banner_message_text').with(
          'ensure' => 'present',
          'path'   => '/etc/dconf/db/gdm.d/01-banner-message',
          'line'   => "banner-message-text='Secure Login'",
        ).that_notifies('Exec[refresh_dconf]')
      }

      # Ensure last logged in user display is disabled - Section 1.8.3
      it {
        is_expected.to contain_file_line('gdm_lastlogin_list_disable').with(
          'ensure' => 'present',
          'path'   => '/etc/dconf/db/gdm.d/00-login-screen',
          'line'   => 'disable-user-list=true',
        ).that_notifies('Exec[refresh_dconf]')
      }

      # Ensure XDCMP Not Enabled - Section 1.8.4
      it {
        is_expected.to contain_file_line('xdcmp_disable').with(
          'ensure' => 'present',
          'path'   => '/etc/gdm/custom.conf',
          'match'  => '^Enable=true',
          'line'   => 'Enable=false',
        ).that_notifies('Exec[refresh_dconf]')
      }

      # Ensure that Refresh dconf exists
      it {
        is_expected.to contain_exec('refresh_dconf').with(
          'path'    => '/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin',
          'command' => 'dconf update',
        )
      }

      # Ensure it compiles with all dependencies
      it {
        is_expected.to compile.with_all_deps
      }
    end
  end
end
