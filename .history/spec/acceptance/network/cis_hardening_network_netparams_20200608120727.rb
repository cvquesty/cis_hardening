require 'spec_helper_acceptance'

# Ensure IP Forwarding is disabled - Section 3.1.1
# Ensure packet redirect sending is disabled - Section 3.1.2
# Ensure source routed packets are not accepted - Section 3.2.1
describe file('/etc/sysctl.d/99-sysctl.conf') do
    it { should be_symlink }
    it { should be_owned_by 'root' }
    it { should be_grouped_into 'root' }
    its (:content) { should match /net.ipv4.ip_forward = 0/ }
    its (:content) { should match /net.ipv4.conf.all.send_redirects = 0/ }
    its (:content) { should match /net.ipv4.conf.default.send_redirects = 0/ }
    its (:content) { }
end