require 'spec_helper_acceptance'

# Ensure IP Forwarding is disabled - Section 3.1.1
describe file('/etc/sysctl.d/99-sysctl.conf') do
    it { should be_symlink }
    it { should be_owned_by 'root' }
    it { should be_grouped_into 'root' }
    its ()
end