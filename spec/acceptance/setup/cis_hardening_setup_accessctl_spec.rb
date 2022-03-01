require 'spec_helper_acceptance'

describe 'Access Control Settings' do
  # Ensure SELinux is not disabled in bootloader configuration - Section 1.6.1.1
  describe file('/etc/default/grub') do
    it { is_expected.to be_file }
    it { is_expected.to be_owned_by 'root' }
    it { is_expected.to be_grouped_into 'root' }
    it { is_expected.to be_mode 0o0644 }
    it {
      its(:content) { is_expected.to match %r{/GRUB_CMDLINE_LINUX_DEFAULT="quiet"/} }
    }
    it {
      its(:content) { is_expected.to match %r{/GRUB_CMDLINE_LINUX="audit=1"/} }
    }
  end

  # Ensure the SELinux state is "enforcing" - Section 1.6.1.2
  describe file('/etc/selinux/config') do
    it { is_expected.to be_file }
    it { is_expected.to be_owned_by 'root' }
    it { is_expected.to be_grouped_into 'root' }
    it { is_expected.to be_mode 0o0644 }
    it {
      its(:content) { is_expected.to match %r{/SELINUX=enforcing/} }
    }
    it {
      its(:content) { is_expected.to match %r{/SELINUXTYPE=targeted/} }
    }
  end

  # Ensure SETroubleshoot is not installed - Section 1.6.1.4
  describe package('setroubleshoot') do
    it { is_expected.not_to be_installed }
  end

  # Ensure MCS Translation Service is not installed - Section 1.6.1.5
  describe package('mcstrans') do
    it { is_expected.not_to be_installed }
  end

  # Ensure SELinux is installed - Section 1.6.2
  describe package('libselinux') do
    it { is_expected.to be_installed }
  end
end
