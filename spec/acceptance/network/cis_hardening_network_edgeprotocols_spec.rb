require 'spec_helper_acceptance'

describe 'Disable edge networking protocols' do
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
    it { is_expected.to be_mode 0o0644 }
    it {
      its(:content) { is_expected.to match %r{/install dccp \/bin\/true/} }
    }
    it {
      its(:content) { is_expected.to match %r{/install sctp \/bin\/true/} }
    }
    it {
      its(:content) { is_expected.to match %r{/install rds \/bin\/true/} }
    }
    it {
      its(:content) { is_expected.to match %r{/install tipc \/bin\/true/} }
    }
  end
end
