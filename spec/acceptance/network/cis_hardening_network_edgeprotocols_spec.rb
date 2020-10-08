require 'spec_helper_acceptance'

describe 'cis_hardening_network_aedgeprotocols class' do
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
    it { is_expected.to be_file }
    it { is_expected.to be_owned_by 'root' }
    it { is_expected.to be_grouped_into 'root' }
    it { is_expected.to be_mode 644 }
    its(:content) { is_expected.to match (/install dccp \/bin\/true/) }
    its(:content) { is_expected.to match (/install sctp \/bin\/true/) }
    its(:content) { is_expected.to match (/install rds \/bin\/true/) }
    its(:content) { is_expected.to match (/install tipc \/bin\/true/) }
end
