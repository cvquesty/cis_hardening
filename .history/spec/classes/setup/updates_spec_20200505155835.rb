require 'spec_helper'

describe 'cis_hardening::setup::updates' do
  on_supported_os.each do |os, os_facts|
    context "on #{os}" do
      let(:facts) { os_facts }

      # Check for main class
      it {
        is_expected.to contain_class('cis_hardening::setup::updates')
      }

      # Ensure gpgcheck is globally activated - Section 1.2.3
      it {
        is_expected.to contain_file_line('gpgcheck').with(
          'ensure' => 'present',
          'path'   => '/etc/yum.conf',
          'line'   => 'gpgcheck=1',
          'match'  => '^gpgcheck\=',
        )
      }

      # Ensure manifest compiles with all dependencies
      it { is_expected.to compile.with_all_deps }
    end
  end
end
