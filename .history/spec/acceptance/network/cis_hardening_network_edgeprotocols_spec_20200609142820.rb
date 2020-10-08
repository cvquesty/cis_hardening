require 'spec_helper_acceptance'

describe 'cis_hardening_network_accounts class' do
  context 'default parameters' do
    it 'behaves idempotently' do
      idempotent_apply(pp)
    end
  end
end

# Ensure DCCP is disabled - Section 3.5.1
# Ensure SCTP is disabled - Section 3.5.2
# Ensure RDS is disabled - Section 3.5.3
# Ensure TIPC is disabled - Section 3.5.4
describe file('/etc/modprobe.d/CIS.conf') do
    it { should be_file }
    it { should be_owned_by 'root' }
    it { should be_grouped_into 'root' }
    it { should be_mode 644 }
    its(:content) { should match /install dccp \/bin\/true/ }
    its(:content) { should match /install sctp \/bin\/true/ }
    its(:content) { should match /install rds \/bin\/true/ }
    its(:content) { should match /install tipc \/bin\/true/ }
end