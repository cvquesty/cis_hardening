require 'spec_helper_acceptance'

# Ensure IP Forwarding is disabled - Section 3.1.1
describe file('/etc/sysctl.d/99-sysctl.conf') do
    it { should be_symlink }
end