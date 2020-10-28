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

      # Configure IPTables - Section 3.5.3
      # Section 3.5.3.1 - Configure Software

      # Ensure IPTables packages are installed - 3.5.3.1.1
      it {
        is_expected.to contain_package('iptables').with(
          'ensure' => 'present',
        )
      }

      it {
        is_expected.to contain_package('iptables-services').with(
          'ensure' => 'present',
        )
      }

      # Configure IPv4 IPTables - 3.5.3.2
    # Ensure Default deny Firewall Policy - Section 3.5.3.2.1
    # Ensure loopback traffic is configured - Section 3.5.3.2.2
    # Ensure outbound and established connections are configured - Section 3.5.3.2.3
    # Ensure Firewall rules exist for all open ports - Section 3.5.3.2.4
    # Ensure IPTables rules are saved - Section 3.5.3.2.5

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
