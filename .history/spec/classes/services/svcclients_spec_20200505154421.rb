require 'spec_helper'

describe 'cis_hardening::services::svcclients' do
  on_supported_os.each do |os, os_facts|
    context "on #{os}" do
      let(:facts) { os_facts }

      # Check for main class
      it {
        is_expected.to contain_class('cis_hardening::services::svcclients')
      }

      # Ensure NIS CLient is not installed - Section 2.3.1
      it {
        is_expected.to contain_package('ypbind').with(
          'ensure' => 'absent',
        )
      }

      # Ensure rsh Client is not installed - Section 2.3.2
      it {
        is_expected.to contain_package('rsh').with(
          'ensure' => 'absent',
        )
      }

      # Ensure talk client is not installed - Section 2.3.3
      it {
        is_expected.to contain_package('talk').with(
          'ensure' => 'absent',
        )
      }

      # Ensure telnet client is not installed - Section 2.3.4
      it {
        is_expected.to contain_package('telnet').with(
          'ensure' => 'absent',
        )
      }

      # Ensure LDAP client is not installed - Section 2.3.5
      it {
        is_expected.to contain_package('openldap-clients').with(
          'ensure' => 'absent',
        )
      }

      # Ensure manifest compiles with all dependencies
      it {
        is_expected.to compile.with_all_deps
      }
    end
  end
end