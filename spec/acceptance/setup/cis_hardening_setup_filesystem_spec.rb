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
  # Ensure mounting of hfs filesystems is disabled - Section 1.1.1.4
  # Ensure mounting of hfsplus filesystems is disabled - Section 1.1.1.5
  # Ensure mounting of squashfs filesystems is disabled - Section 1.1.1.6
  # Ensure mounting of udf filesystem is disabled - Section 1.1.1.7
  describe file('/etc/modprobe.d/CIS.conf') do
    it { is_expected.to be_file }
    it { is_expected.to be_owned_by 'root' }
    it { is_expected.to be_grouped_into 'root'}
    it { is_expected.to be_mode 644 }
    its(:content) { is_expected.to match (/install cramfs \/bin\/true/) }
    its(:content) { is_expected.to match (/install freevxfs \/bin\/true/) }
    its(:content) { is_expected.to match (/install jffs2 \/bin\/true/) }
    its(:content) { is_expected.to match (/install hfs \/bin\/true/) }
    its(:content) { is_expected.to match (/install hfsplus \/bin\/true/) }
    its(:content) { is_expected.to match (/install squashfs \/bin\/true/) }
    its(:content) { is_expected.to match (/install udf \/bin\/true/) }
    its(:content) { is_expected.to match (/install vfat \/bin\/true/) }
  end

  # Logger lines omitted. If changes in the way we monitor happen, we
  # can revisit

  # Disable Automounting - Section 1.1.22
  describe service('autofs') do
    it { is_expected.not_to be_enabled }
    it { is_expected.not_to be_running }
  end
end
