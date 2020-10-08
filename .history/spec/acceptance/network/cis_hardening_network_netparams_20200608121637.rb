require 'spec_helper_acceptance'

# Ensure IP Forwarding is disabled - Section 3.1.1
# Ensure packet redirect sending is disabled - Section 3.1.2
# Ensure source routed packets are not accepted - Section 3.2.1
# Ensure ICMP redirects are not accepted - Section 3.2.2
# Ensure secure ICMP redirects are not accepted - Section 3.2.3
# Ensure suspicious packets are logged - Section 3.2.4
# Ensure broadcast ICMP requests are ignored - Section 3.2.5
# Ensure bogus ICMP responses are ignored - Section 3.2.6
# Ensure reverse path filtering is enabled - Section 3.2.7
describe file('/etc/sysctl.d/99-sysctl.conf') do
    it { should be_symlink }
    it { should be_owned_by 'root' }
    it { should be_grouped_into 'root' }
    its (:content) { should match /net.ipv4.ip_forward = 0/ }
    its (:content) { should match /net.ipv4.conf.all.send_redirects = 0/ }
    its (:content) { should match /net.ipv4.conf.default.send_redirects = 0/ }
    its (:content) { should match /net.ipv4.conf.all.accept_source_route = 0/ }
    its (:content) { should match /net.ipv4.conf.default.accept_source_route = 0/ }
    its (:content) { should match /net.ipv4.conf.all.accept_redirects = 0/ }
    its (:content) { should match /net.ipv4.conf.default.accept_redirects = 0/ }
    its (:content) { should match /net.ipv4.conf.all.secure_redirects = 0/ }
    its (:content) { should match /net.ipv4.conf.default.secure_redirects = 0/ }
    its (:content) { should match /net.ipv4.conf.all.log_martians = 1/ }
    its (:content) { should match /net.ipv4.conf.default.log_martians = 1/ }
    its (:content) { should match /net.ipv4.icmp_echo_ignore_broadcasts = 1/ }
    its (:content) { should match /net.ipv4.icmp_ignore_bogus_error_responses = 1/ }
    its (:content) { should match /net.ipv4.conf.all.rp_filter = 1/ }
    its (:content) 
end