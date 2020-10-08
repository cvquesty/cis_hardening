require 'spec_helper'

describe 'cis_hardening::maint::fileperms' do
  on_supported_os.each do |os, os_facts|
    context "on #{os}" do
      let(:facts) { os_facts }

      # Check for default Class
      it { is_expected.to contain_class('cis_hardening::maint::fileperms')}

      # Ensure that Ensure permissions on /etc/passwd are configured - Section 6.1.2
      it { is_expected.to contain_file('/etc/passwd').with(
        'ensure' => 'present',
        'owner'  => 'root',
        'group'  => 'root',
        'mode'   => '0644',
      )}

      # Ensure that Ensure permissions on /etc/shadow are configured - Section 6.1.3
      it { is_expected.to contain_file('/etc/shadow').with(
        'ensure' => 'present',
        'owner'  => 'root',
        'group'  => 'root',
        'mode'   => '0000',
      )}

      # Ensure that Ensure permissions on /etc/group are configured - Section 6.1.4
      it { is_expected.to contain_file('/etc/group').with(
        'ensure' => 'present',
        'owner'  => 'root',
        'group'  => 'root',
        'mode'   => '0644',
      )}

      # Ensure that Ensure Permissions on /etc/gshadow are configured - Section 6.1.5
      it { is_expected.to contain_file('/etc/gshadow').with(
        'ensure' => 'present',
        'owner'  => 'root',
        'group'  => 'root',
        'mode'   => '0000',
      )}

      # Ensure that Ensure permissions on /etc/passwd- are configured - Section 6.1.6
      it { is_expected.to contain_file('/etc/passwd-').with(
        'ensure' => 'present',
        'owner'  => 'root',
        'group'  => 'root',
        'mode'   => '0644',
      )}

      # Ensure that Ensure permissions on /etc/shadow- are configured - Section 6.1.7
      it { is_expected.to contain_file('/etc/shadow-').with(
        'ensure' => 'present',
        'owner'  => 'root',
        'group'  => 'root',
        'mode'   => '0000',
      ) }

      # Ensure that Ensure permissions on /etc/group- are configured - Section 6.1.8
      it { is_expected.to contain_file('/etc/group-').with(
        'ensure' => 'present',
        'owner'  => 'root',
        'group'  => 'root',
        'mode'   => '0644',
      )}

      # Ensure that Ensure permissions on /etc/gshadow- are configured - Section 6.1.9
      it { is_expected.to contain_file('/etc/gshadow-').with(
        'ensure' => 'present',
        'owner'  => 'root',
        'group'  => 'root',
        'mode'   => '0000',
      )}

      # Ensure manifest compiles with all dependencies
      it { is_expected.to compile.with_all_deps }
    end
  end
end
