require 'spec_helper'

describe 'cis_hardening::auth::pam' do
  on_supported_os.each do |os, os_facts|
    context "on #{os}" do
      let(:facts) { os_facts }

      # Check for default class
      it { is_expected.to contain_class('cis_hardening::auth::pam')}

      # Ensure that Ensure Password creation requirements are configured - Section 5.3.1
      it { is_expected.to contain_file('/etc/security/pwquality.conf').with(
        'ensure' => 'present',
        'owner'  => 'root',
        'group'  => 'root',
        'mode'   => '0644',
        'source' => 'puppet:///modules/cis_hardening/pwquality.conf',
      )}

      # Ensure that Ensure lockout delay for failed password attempts is configured - Section 5.3.2
      it { is_expected.to contain_exec('enable_lockout_delay_sysauthac').with(
        'path'    => '/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin',
        'command' => "perl -i -e 's/pam_faildelay.so.*$/pam_faildelay.so delay=2000000/' /etc/pam.d/system-auth-ac",
        'unless'  => "grep 'delay=2000000' /etc/pam.d/system-auth-ac",
      )}

      it { is_expected.to contain_exec('enable_lockout_delay_passauthac').with(
        'path'    => '/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin',
        'command' => "perl -i -e 's/pam_faildelay.so.*$/pam_faildelay.so delay=2000000/' /etc/pam.d/password-auth-ac",
        'unless'  => "grep 'delay=2000000' /etc/pam.d/password-auth-ac",
      )}

      # Ensure that Ensure Password Reuse is Limited - Section 5.3.3
      it { is_expected.to contain_exec('limit_pw_reuse_sysauthac').with(
        'path'    => '/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin',
        'command' => "perl -pi -e 's/$/ remember=5/ if /^password\s+sufficient\s+pam_unix.so/' /etc/pam.d/system-auth-ac",
        'unless'  => "grep 'remember=5' /etc/pam.d/system-auth-ac",
      )}

      it { is_expected.to contain_exec('limit_pw_reuse_passauthac').with(
        'path'    => '/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin',
        'command' => "perl -pi -e 's/$/ remember=5/ if /^password\s+sufficient\s+pam_unix.so/' /etc/pam.d/password-auth-ac",
        'unless'  => "grep 'remember=5' /etc/pam.d/password-auth-ac",
      )}

      # Ensure that Ensure Password Hashing Algorithm is SHA-512 - Section 5.3.4
      it { is_expected.to contain_exec('set_pw_hashing_algo_sysauthac').with(
        'path'    => '/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin',
        'command' => "perl -pi -e 's/$/ sha512/ if /^password\s+sufficient\s+pam_unix.so/' /etc/pam.d/system-auth-ac",
        'unless'  => 'grep sha512 /etc/pam.d/system-auth-ac',
      )}

      it { is_expected.to contain_exec('set_pw_hashing_algo_passauthac').with(
        'path'    => '/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin',
        'command' => "perl -pi -e 's/$/ sha512/ if /^password\s+sufficient\s+pam_unix.so/' /etc/pam.d/password-auth-ac",
        'unless'  => 'grep sha512 /etc/pam.d/password-auth-ac',
      )}

      # Ensure manifest compiles with all dependencies
      it { is_expected.to compile.with_all_deps }
    end
  end
end
