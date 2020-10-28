require 'spec_helper'

describe 'cis_hardening::network::firewall' do
  on_supported_os.each do |os, os_facts|
    context "on #{os}" do
      let(:facts) { os_facts }

      # Check for default class
      it {
        is_expected.to contain_class('cis_hardening::network::firewall')
      }

      # Section 3.5.1
      # This specification does not include the installation and usage of FirewallD, but IPTables.
      # Below is the configuration of IPTables as defined.
      #
      # FirewallD Controls skipped or ignored for this specification:
      #
      # 3.5.1.1, 3.5.1.2, 3.5.1.4, 3.5.1.5, 3.5.1.6, 3.5.1.7

      # Ensure FirewallD is not installed or stopped and Masked - 3.5.2.2, 3.5.3.1.3
      it {
        is_expected.to contain_package('firewalld').with(
          'ensure' => 'absent',
        )
      }

      # Ensure nftables is not installed or stopped and masked - 3.5.1.3, 3.5.3.1.2
      it {
        is_expected.to contain_package('nftables').with(
          'ensure' => 'absent',
        )
      }

      # Configure nftables - 3.5.2
    # We have disabled nftables above, therefore the controls to be skiped or ignored are:
    #
    # 3.5.2.1, 3.5.2.2, 3.5.2.3, 3.5.2.4, 3.5.2.5, 3.5.2.6, 3.5.2.7, 3.5.2.8, 3.5.2.9, 3.5.2.10
~   # 3.5.2.11,

      # Ensure IPTables is installed
      it {
        is_expected.to contain_package('iptables').with(
          'ensure' => 'present',
        )
      }

      # Ensure config file is being placed
      it {
        is_expected.to contain_file('/etc/sysconfig/iptables').with(
          'ensure' => 'present',
          'owner'  => 'root',
          'group'  => 'root',
          'mode'   => '0600',
          'source' => 'puppet:///modules/cis_hardening/iptables.conf',
        )
      }

      # Ensure it compiles with all dependencies
      it {
        is_expected.to compile.with_all_deps
      }
    end
  end
end
