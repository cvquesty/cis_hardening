require 'spec_helper_acceptance'

describe ' TCP Wrappers Settings' do
  describe 'cis_hardening_network_tcpwrappers class' do
    context 'default parameters' do
      it 'behaves idempotently' do
        idempotent_apply(pp)
      end
    end
  end

  # Verify TCP Wrappers are installed - Section 3.4.1
  describe package('tcp_wrappers') do
    it { is_expected.to be_installed }
  end

  # Ensure /etc/hosts.allow is configured - Section 3.4.2, 3.4.4
  describe file('/etc/hosts.allow') do
    it { is_expected.to be_file }
    it { is_expected.to be_owned_by 'root' }
    it { is_expected.to be_grouped_into 'root' }
    it { is_expected.to be_mode 0o0644 }
  end
end
