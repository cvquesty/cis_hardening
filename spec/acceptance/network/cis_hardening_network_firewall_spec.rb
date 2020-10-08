require 'spec_helper_acceptance'

describe 'Network Firewall Configuration' do
  describe 'cis_hardening_network_firewall class' do
    context 'default parameters' do
      it 'behaves idempotently' do
        idempotent_apply(pp)
      end
    end
  end

  # Ensure IPTables is installed - Section 3.6.1
  describe package('iptables') do
      it { is_expected.to be_installed }
  end

  # Ensure Default deny Firewall Policy - Section 3.6.2
  # Ensure loopback traffic is configured - Section 3.6.3
  # Ensure outbound and established connections are configured - Section 3.6.4
  # Ensure Firewall rules exist for all open ports - Section 3.6.5
  # Ensure wireless interfaces are disabled - Section 3.7
  describe file('/etc/sysconfig/iptables') do
      it { is_expected.to be_file }
      it { is_expected.to be_owned_by 'root' }
      it { is_expected.to be_grouped_into 'root' }
      it { is_expected.to be_mode 600 }
      its (:content) { is_expected.to match %r{/# This File Managed by Puppet. DO NOT EDIT./} }
      its (:content) { is_expected.to match %r{/-A INPUT -p tcp --dport 22 -m state --state NEW -j ACCEPT/} }
  end
end
