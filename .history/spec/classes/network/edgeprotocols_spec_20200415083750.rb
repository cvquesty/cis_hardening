require 'spec_helper'

describe 'cis_hardening::network::edgeprotocols' do
  on_supported_os.each do |os, os_facts|
    context "on #{os}" do
      let(:facts) { os_facts }

      # Check for default class
      it { is_expected.to contain_class('cis_hardening::network::edgeprotocols')}

      # Ensure that DCCP is disabled - Section 3.5.1
      it { is_expected.to contain_file_line('dccp_disable').with(
        'ensure' => 'present',
        'path'   => '/etc/modprobe.d/CIS.conf',
        'line'   => 'install dccp /bin/true',
      )}

      # Ensure that SCTP is disabled - Section 3.5.2
      it { is_expected.to contain_file_line('sctp_disable').with(
        'ensure' => 'present',
        'path'   => '/etc/modprobe.d/CIS.conf',
        'line'   => 'install sctp /bin/true',
      )}

      # Ensure that RDS is disabled - Section 3.5.3
      it { is_expected.to contain_file_line('rds_disable').with(
        'ensure' => 'present',
        'path'   => '/etc/modprobe.d/CIS.conf',
        'line'   => 'install rds /bin/true',
      )}

      # Ensure that TIPC is disabled - Section 3.5.4
      it { is_expected.to contain_file_line('tipc_disable').with(
        'ensure' => 'present',
        'path'   => '/etc/modprobe.d/CIS.conf',
        'line'   => 'install tipc /bin/true',
      )}

      # Ensure manifest compiles with all dependencies
      it { is_expected.to compile.with_all_deps }
    end
  end
end
