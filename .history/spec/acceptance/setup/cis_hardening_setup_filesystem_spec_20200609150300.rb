require 'spec_helper_acceptance'

describe 'cis_hardening_setup_filesystem class' do
  context 'default parameters' do
    it 'behaves idempotently' do
      idempotent_apply(pp)
    end
  end

  # Disable unused Filesystems - Section 1.1.1
  describe file('/etc/modprobe.d/CIS.conf') do
      it { should be_file }
      it { should be_owned_by 'root' }
      it { should be_grouped_into 'root'}
      it { should be_mode 644 }
      its(:content) { should match /install cramfs \/bin\/true/ }
      its(:content) { should match /install freevxfs \/bin\/true/ }
      
  end
end