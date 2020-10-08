require 'spec_helper'

describe 'cis_hardening::auth::ssh' do
  on_supported_os.each do |os, os_facts|
    context "on #{os}" do
      let(:facts) { os_facts }

      # Check for default class
      it {
        is_expected.to contain_class('cis_hardening::auth::ssh')
      }

      # Ensure that Ensure permissions on /etc/ssh/sshd_config are configured - Section 5.2.1
      it {
        is_expected.to contain_file('/etc/ssh/sshd_config').with(
          'ensure' => 'file',
          'owner'  => 'root',
          'group'  => 'root',
          'mode'   => '0600',
        )
      }

      # Ensure that Set sshd_config Options - Section 5.2.2
      it {
        is_expected.to contain_file_line('set_ssh_protocol').with(
          'ensure' => 'present',
          'path'   => '/etc/ssh/sshd_config',
          'line'   => 'Protocol 2',
        )
      }

      # Ensure that Set SSH LogLevel to INFO - Section 5.2.3
      it {
        is_expected.to contain_file_line('set_ssh_loglevel').with(
          'ensure' => 'present',
          'path'   => '/etc/ssh/sshd_config',
          'line'   => 'LogLevel INFO',
        )
      }

      # Ensure that Ensure SSH X11 Forwarding is disabled - Section 5.2.4
      it {
        is_expected.to contain_file_line('set_x11_forwarding').with(
          'ensure' => 'present',
          'path'   => '/etc/ssh/sshd_config',
          'line'   => 'X11Forwarding no',
        )
      }

      # Ensure that Ensure SSH MaxAuthTries is set to 4 or less - Section 5.2.5
      it {
        is_expected.to contain_file_line('set_ssh_maxauthtries').with(
          'ensure' => 'present',
          'path'   => '/etc/ssh/sshd_config',
          'line'   => 'MaxAuthTries 4',
        )
      }

      # Ensure that Ensure SSH IgnoreRhosts is enabled - Section 5.2.6
      it {
        is_expected.to contain_file_line('set_ssh_ignore_rhosts').with(
          'ensure' => 'present',
          'path'   => '/etc/ssh/sshd_config',
          'line'   => 'IgnoreRhosts yes',
        )
      }

      # Ensure that Ensure SSH HostBased Authentication is Disabled - Section 5.2.7
      it {
        is_expected.to contain_file_line('set_hostbasedauth_off').with(
          'ensure' => 'present',
          'path'   => '/etc/ssh/sshd_config',
          'line'   => 'HostBasedAuthentication no',
        )
      }

      # Ensure that Ensure SSH Root Login is Disabled - Section 5.2.8
      it {
        is_expected.to contain_file_line('set_rootlogin_no').with(
          'ensure' => 'present',
          'path'   => '/etc/ssh/sshd_config',
          'line'   => 'PermitRootLogin no',
        )
      }

      # Ensure that Ensure PermitEmptyPasswords is Disabled - Section 5.2.9
      it {
        is_expected.to contain_file_line('set_emptypasswords_off').with(
          'ensure' => 'present',
          'path'   => '/etc/ssh/sshd_config',
          'line'   => 'PermitEmptyPasswords no',
        )
      }

      # Ensure that Ensure SSH PermitUserEnvironment is Disabled - Section 5.2.10
      it {
        is_expected.to contain_file_line('set_permituserenv_off').with(
          'ensure' => 'present',
          'path'   => '/etc/ssh/sshd_config',
          'line'   => 'PermitUserEnvironment no',
        )
      }

      # Ensure that Ensure only approved MAC algorithms are used - Section 5.2.11
      # Not used: this is a manual step that needs to be verified and validated by
      # an authorized person

      # Ensure that Ensure SSH Idle Timeout Interval is configured - Section 5.2.12
      it {
        is_expected.to contain_file_line('client_alive_interval').with(
          'ensure' => 'present',
          'path'   => '/etc/ssh/sshd_config',
          'line'   => 'ClientAliveInterval 300',
        )
      }

      it {
        is_expected.to contain_file_line('client_alive_count_max').with(
          'ensure' => 'present',
          'path'   => '/etc/ssh/sshd_config',
          'line'   => 'ClientAliveCountMax 0',
        )
      }

      # Ensure that Ensure SSH LoginGraceTime is set to One Minute or Less - Section 5.2.13
      it {
        is_expected.to contain_file_line('login_grace_time').with(
          'ensure' => 'present',
          'path'   => '/etc/ssh/sshd_config',
          'line'   => 'LoginGraceTime 60',
        )
      }

      # Ensure SSH Access is Limited - Section 5.2.14
      # Unused in sshd_config. Managed via IAM
      # Ensure SSH Warning Banner is Configured
      it {
        is_expected.to contain_file_line('set_ssh_banner').with(
          'ensure' => 'present',
          'path'   => '/etc/ssh/sshd_config',
          'line'   => 'Banner /etc/issue.net',
        )
      }

      # Ensure manifest compiles with all dependencies
      it {
        is_expected.to compile.with_all_deps
      }
    end
  end
end
