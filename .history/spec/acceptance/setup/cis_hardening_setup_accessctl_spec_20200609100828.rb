require 'spec_helper_acceptance'

# Ensure SELinux is not disabled in bootloader configuration - Section 1.6.1.1
describe file('/etc/default/grub') do
    it { should be_file }
    it { should be_owned_by 'root' }
    it { should be_grouped_into 'root' }
    it { should be_mode 644 }
    its(:content) { should match /GRUB_CMDLINE_LINUX_DEFAULT="quiet"/ }
    its(:content) { should match /GRUB_CMDLINE_LINUX="audit=1"/ }
end

# Ensure the SELinux state is "enforcing" - Section 1.6.1.2
describe file('/etc/selinux/config') do
    it { should be_file }
    it { should be_owned_by 'root' }
    it { should be_grouped_into 'root' }
    it { should be_mode 644 }
    its(:content) { should match /SELINUX=enforcing/ }
    its(:content) { should match /SELINUXTYPE=targeted/ }
end

# Ensure SETroubleshoot is not installed - Section 1.6.1.4
describe package('setroubleshoot') do
    it { should}
end

