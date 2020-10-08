require 'spec_helper_acceptance'

describe 'cis_hardening_network_accounts class' do
  context 'default parameters' do
    it 'behaves idempotently' do
      idempotent_apply(pp)
    end
  end
end

# Ensure IPTables is installed - Section 3.6.1
describe package('iptables') do
    it { should be_installed }
end

# Ensure Default deny Firewall Policy - Section 3.6.2
# Ensure loopback traffic is configured - Section 3.6.3
# Ensure outbound and established connections are configured - Section 3.6.4
# Ensure Firewall rules exist for all open ports - Section 3.6.5
# Ensure wireless interfaces are disabled - Section 3.7
describe file('/etc/sysconfig/iptables') do
    it { should be_file }
    it { should be_owned_by 'root' }
    it { should be_grouped_into 'root' }
    it { should be_mode 600 }
    its (:content) { should match /# This File Managed by Puppet. DO NOT EDIT./ }
    its (:content) { should match /-A INPUT -p tcp --dport 22 -m state --state NEW -j ACCEPT/ }
end