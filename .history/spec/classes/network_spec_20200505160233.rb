require 'spec_helper'

describe 'cis_hardening::network' do
  on_supported_os.each do |os, os_facts|
    context "on #{os}" do
      let(:facts) { os_facts }

      # Check for default class
      it {
        is_expected.to contain_class('cis_hardening::network')
      }

      # Check for all includes in the network.pp
      it {
        is_expected.to contain_class('cis_hardening::network::netparams')
      }
      it {
        is_expected.to contain_class('cis_hardening::network::tcpwrappers')
      }
      it {
        is_expected.to contain_class('cis_hardening::network::ipv6')
      }
      it {
        is_expected.to contain_class('cis_hardening::network::firewall')
      }
      it {
        is_expected.to contain_class('cis_hardening::network::edgeprotocols')
      }

      # Ensure manifest compiles with all dependencies
      it {
        is_expected.to compile.with_all_deps
      }
    end
  end
end
