require 'spec_helper'

describe 'cis_hardening::auth::accounts' do
  on_supported_os.each do |os, os_facts|
    context "on #{os}" do
      let(:facts) { os_facts }

      # Check for default class
      it {
        is_expected.to contain_class('cis_hardening::auth::accounts')
      }

      # Ensure Perl is installed
      it {
        is_expected.to contain_package('perl').with(
          'ensure' => 'present',
        )
      }

      # Check that Ensure Password expiration is 365 days or less - Section 5.4.1.1
      it {
        is_expected.to contain_file_line('pass_max_days').with(
          'ensure' => 'present',
          'path'   => '/etc/login.defs',
          'line'   => 'PASS_MAX_DAYS 365',
          'match'  => '^PASS_MAX_DAYS\ ',
        )
      }

      # Check that Ensure minimum days between password changes is 7 or more - Section 5.4.1.2
      it {
        is_expected.to contain_file_line('pass_min_days').with(
          'ensure' => 'present',
          'path'   => '/etc/login.defs',
          'line'   => 'PASS_MIN_DAYS 7',
          'match'  => '^PASS_MIN_DAYS\ ',
        )
      }

      # Check that Ensure Pasword Expiration warning days is 7 or more - Section 5.4.1.3
      it {
        is_expected.to contain_exec('pass_warn_age').with(
          'path'    => '/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin',
          'command' => "perl -pi -e 's/PASS_WARN_AGE.*$/PASS_WARN_AGE 7/' /etc/login.defs",
          'onlyif'  => "test ! `grep ^PASS_WARN_AGE /etc/login.defs |awk '{print \$2}'` -lt 7",
        )
      }

      # Check that Ensure default group for the root account is GID 0 - Section 5.4.3
      it {
        is_expected.to contain_user('root').with(
          'ensure' => 'present',
          'gid'    => 'root',
        )
      }

      # Check that Ensure default user umask is 027 or more restrictive - Section 5.4.4
      it {
        is_expected.to contain_exec('set_login_umask_etcprofile').with(
          'path'    => '/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin',
          'command' => "echo \"umask 027\" >> /etc/profile",
          'onlyif'  => 'test ! `grep umask |grep 027 /etc/profile`',
        )
      }

      it {
        is_expected.to contain_exec('set_login_umask_etcbashrc').with(
          'path'    => '/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin',
          'command' => "perl -pi -e 's/umask.*$/umask 027/' /etc/bashrc",

          'unless'  => 'test `grep umask /etc/bashrc`',
        )
      }

      # Check that Ensure default user shell tieout is 900 seconds or less - Section 5.4.5
      it {
        is_expected.to contain_exec('set_user_timeout_etcprofile').with(
          'path'    => '/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin',
          'command' => "echo TMOUT=600 >> /etc/profile",
          'onlyif'  => 'test ! `grep ^TMOUT /etc/profile`',
        )
      }

      it {
        is_expected.to contain_exec('set_user_timeout_etcbashrc').with(
          'path'    => '/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin',
          'command' => "echo \"TMOUT=600\" >> /etc/bashrc",
          'onlyif'  => 'test ! `grep TMOUT /etc/bashrc`',
        )
      }

      # Ensure manifest compiles with all dependencies
      it {
        is_expected.to compile.with_all_deps
      }
    end
  end
end
