require 'spec_helper'

describe 'cis_hardening::network::tcpwrappers' do
  on_supported_os.each do |os, os_facts|
    context "on #{os}" do
      let(:facts) { os_facts }

      # Check for default class
      it {
        is_expected.to contain_class('cis_hardening::network::tcpwrappers')
      }

      # Ensure TCP Wrappers are installed - Section 3.4.1
      it {
        is_expected.to contain_package('tcp_wrappers').with(
          'ensure' => 'present',
        )
      }

      # Ensure /etc/hosts.allow is configured - Section 3.4.2, 3.4.4
      it {
        is_expected.to contain_file('/etc/hosts.allow').with(
          'ensure' => 'present',
          'owner'  => 'root',
          'group'  => 'root',
          'mode'   => '0644',
        )
      }

      # Ensure it compiles with all dependencies
      it {
        is_expected.to compile.with_all_deps
      }
    end
  end
end
