require 'spec_helper_acceptance'

describe 'cis_hardening_setup_filesystem class' do
  context 'default parameters' do
    it 'behaves idempotently' do
      idempotent_apply(pp)
    end
  end

  # Disable unused Filesystems - Section 1.1.1
  # Ensure mounting of cramfs filesystems is disabled - Section 1.1.1.1
  # Ensure mounting of freevxfs filesystems is disabled - Section 1.1.1.2
  # Ensure mounting of jffs2 Filesystems is disabled - Section 1.1.1.3
  
  describe file('/etc/modprobe.d/CIS.conf') do
      it { should be_file }
      it { should be_owned_by 'root' }
      it { should be_grouped_into 'root'}
      it { should be_mode 644 }
      its(:content) { should match /install cramfs \/bin\/true/ }
      its(:content) { should match /install freevxfs \/bin\/true/ }
      its(:content) { should match /install jffs2 \/bin\/true/ }
      its(:content) { should match /install hfs \/bin\/true/ }
      its(:content) { should match /install hfsplus \/bin\/true/ }
      its(:content) { should match /install squashfs \/bin\/true/ }
      its(:content) { should match /install udf \/bin\/true/ }
      its(:content) { should match /install vfat \/bin\/true/ }

  end
end