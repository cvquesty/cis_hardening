require 'spec_helper_acceptance'

# Ensure SELinux is not disabled in bootloader configuration - Section 1.6.1.1
describe file('/etc/default/grub') do
    it { should be_file }
    it 
end