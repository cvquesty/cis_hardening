require 'spec_helper_acceptance'

# Ensure IPv6 router advertisements are not accepted - Section 3.3.1
describe file ( '/etc/sysctl.d/99-sysctl.conf' ) do
    it { should be_symlink }
    it { should be_owned_by 'root' }
    it { should be_grouped_into 'root' }
    its (:content) { should match /net.ipv6.conf.all.accept_ra = 0/ }
    its (:content) { should match /net.ipv6.conf.default.accept_ra = 0/ }
    its (:content)
end