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

      # Check that Ensure minimum days between password changes is no less than one day - Section 5.4.1.2
      it {
        is_expected.to contain_file_line('pass_min_days').with(
          'ensure' => 'present',
          'path'   => '/etc/login.defs',
          'line'   => 'PASS_MIN_DAYS 1',
          'match'  => '^PASS_MIN_DAYS\ ',
        )
      }

      # Check that Ensure Pasword Expiration warning days is 7 or more - Section 5.4.1.3
      it {
        is_expected.to contain_file_line('pass_warn_age').with(
          'ensure' => 'present',
          'path'   => '/etc/login.defs',
          'line'   => 'PASS_WARN_AGE 7',
          'match'  => '^PASS_WARN_AGE\ ',
        )
      }

      # Ensure inactive password lock is 30 days or less - Section 5.4.1.4
      it {
        is_expected.to contain_file_line('dormant_lock').with(
          'ensure' => 'present',
          'path'   => '/etc/defaults/useradd',
          'line'   => 'INACTIVE=30',
          'match'  => '^INACTIVE\=',
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
        is_expected.to contain_file('/etc/profile.d/cisumaskprofile.sh').with(
          'ensure'  => 'present',
          'owner'   => 'root',
          'group'   => 'root',
          'mode'    => '0644',
          'content' => 'umask 027',
        )
      }

      it {
        is_expected.to contain_file('/etc/profile.d/cisumaskbashrc.sh').with(
          'ensure'  => 'present',
          'owner'   => 'root',
          'group'   => 'root',
          'mode'    => '0644',
          'content' => 'umask 027',
        )
      }

      # Check that Ensure default user shell tieout is 900 seconds or less - Section 5.4.5
      it {
        is_expected.to contain_file_line('set_user_timeout_etcprofile').with(
          'ensure' => 'present',
          'path'   => '/etc/profile.d/cisumaskprofile.sh',
          'line'   => 'TMOUT=600',
          'match'  => '^TMOUT\=',
        ).that_requires('File[/etc/profile.d/cisumaskprofile.sh]')
      }

      it {
        is_expected.to contain_file_line('set_user_timeout_etcbashrc').with(
          'ensure' => 'present',
          'path'   => '/etc/profile.d/cisumaskbashrc.sh',
          'line'   => 'TMOUT=600',
          'match'  => '^TMOUT\=',
        ).that_requires('File[/etc/profile.d/cisumaskbashrc.sh]')
      }

      # Ensure manifest compiles with all dependencies
      it {
        is_expected.to compile.with_all_deps
      }
    end
  end
end
