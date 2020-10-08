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
        is_expected.to contain_exec('set_ssh_protocol').with(
          'path'    => '/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin',
          'command' => "perl -pi -e 's/^#Protocol.*$/Protocol 2/' /etc/ssh/sshd_config",
          'onlyif'  => 'test ! "grep ^Protocol /etc/ssh/sshd_config"',
        )
      }

      # Ensure that Set SSH LogLevel to INFO - Section 5.2.3
      it {
        is_expected.to contain_exec('set_ssh_loglevel').with(
          'path'    => '/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin',
          'command' => "perl -pi -e 's/^#LogLevel.*$/LogLevel INFO/' /etc/ssh/sshd_config",
          'onlyif'  => 'test ! "grep ^LogLevel /etc/ssh/sshd_config"',
        )
      }

      # Ensure that Ensure SSH X11 Forwarding is disabled - Section 5.2.4
      it {
        is_expected.to contain_exec('set_x11_forwarding').with(
          'path'    => '/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin',
          'command' => "perl -pi -e 's/^#X11Forwarding.*$/X11Forwarding no/' /etc/ssh/sshd_config",
          'onlyif'  => 'test ! "grep ^X11Forwarding /etc/ssh/sshd_config"',
        )
      }

      # Ensure that Ensure SSH MaxAuthTries is set to 4 or less - Section 5.2.5
      it {
        is_expected.to contain_exec('set_ssh_maxauthtries').with(
          'path'    => '/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin',
          'command' => "perl -pi -e 's/^#MaxAuthTries.*$/MaxAuthTries 4/' /etc/ssh/sshd_config",
          'onlyif'  => 'test ! "grep ^MaxAuthTries /etc/ssh/sshd_config"',
        )
      }

      # Ensure that Ensure SSH IgnoreRhosts is enabled - Section 5.2.6
      it {
        is_expected.to contain_exec('set_ssh_ignore_rhosts').with(
          'path'    => '/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin',
          'command' => "perl -pi -e 's/^#IgnoreRhosts.*$/IgnoreRhosts yes/' /etc/ssh/sshd_config",
          'onlyif'  => 'test ! "grep ^IgnoreRhosts /etc/ssh/sshd_config"',
        )
      }

      # Ensure that Ensure SSH HostBased Authentication is Disabled - Section 5.2.7
      it {
        is_expected.to contain_exec('set_hosbasedauth_off').with(
          'path'    => '/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin',
          'command' => "perl -pi -e 's/^#HostbasedAuthentication.*$/HostbasedAuthentication no/' /etc/ssh/sshd_config",
          'onlyif'  => 'test ! "grep ^HostbasedAuthentication /etc/ssh/sshd_config"',
        )
      }

      # Ensure that Ensure SSH Root Login is Disabled - Section 5.2.8
      it {
        is_expected.to contain_exec('set_rootlogin_no').with(
          'path'    => '/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin',
          'command' => "perl -pi -e 's/^#PermitRootLogin.*$/PermitRootLogin no/' /etc/ssh/sshd_config",
          'onlyif'  => 'test ! "grep ^PermitRootLogin /etc/ssh/sshd_config"',
        )
      }

      # Ensure that Ensure PermitEmptyPasswords is Disabled - Section 5.2.9
      it {
        is_expected.to contain_exec('set_emptypasswords_off').with(
          'path'    => '/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin',
          'command' => "perl -pi -e 's/^#PermitEmptyPasswords.*$/PermitEmptyPasswords no/' /etc/ssh/sshd_config",
          'onlyif'  => 'test ! "grep ^PermitEmptyPasswords /etc/ssh/sshd_config"',
        )
      }

      # Ensure that Ensure SSH PermitUserEnvironment is Disabled - Section 5.2.10
      it {
        is_expected.to contain_exec('set_permituserenv_off').with(
          'path'    => '/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin',
          'command' => "perl -pi -e 's/^#PermitUserEnvironment.*$/PermitUserEnvironment no/' /etc/ssh/sshd_config",
          'onlyif'  => 'test ! "grep ^PermitUserEnvironment /etc/ssh/sshd_config"',
        )
      }

      # Ensure that Ensure only approved MAC algorithms are used - Section 5.2.11
      # Not used: this is a manual step that needs to be verified and validated by
      # an authorized person

      # Ensure that Ensure SSH Idle Timeout Interval is configured - Section 5.2.12
      it {
        is_expected.to contain_exec('client_alive_interval').with(
          'path'    => '/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin',
          'command' => "perl -pi -e 's/^#ClientAliveInterval.*$/ClientAliveInterval 300/' /etc/ssh/sshd_config",
          'onlyif'  => 'test ! "grep ^ClientAliveInterval /etc/ssh/sshd_config"',
        )
      }

      it {
        is_expected.to contain_exec('client_alive_count_max').with(
          'path'    => '/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin',
          'command' => "perl -pi -e 's/^#ClientAliveCountMax.*$/ClientAliveCountMax 0/' /etc/ssh/sshd_config",
          'onlyif'  => 'test ! "grep ^ClientAliveCountMax /etc/ssh/sshd_config"',
        )
      }

      # Ensure that Ensure SSH LoginGraceTime is set to One Minute or Less - Section 5.2.13
      it {
        is_expected.to contain_exec('login_grace_time').with(
          'path'    => '/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin',
          'command' => "perl -pi -e 's/^#LoginGraceTime.*$/LoginGraceTime 60/' /etc/ssh/sshd_config",
          'onlyif'  => 'test ! "grep ^LoginGraceTime /etc/ssh/sshd_config"',
        )
      }

      # Ensure SSH Access is Limited - Section 5.2.14
      # Unused in sshd_config. Managed via IAM
      # Ensure SSH Warning Banner is Configured
      it {
        is_expected.to contain_exec('set_ssh_banner').with(
          'path'    => '/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin',
          'command' => "perl -pi -e 's/^#Banner.*$/Banner /etc/issue.net/' /etc/ssh/sshd_config",
          'onlyif'  => 'test ! "grep ^Banner /etc/ssh/sshd_config"',
        )
      }
        
      # Ensure manifest compiles with all dependencies
      it {
        is_expected.to compile.with_all_deps
      }
    end
  end
end
