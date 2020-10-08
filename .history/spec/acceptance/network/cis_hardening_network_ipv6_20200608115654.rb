require 'spec_helper_acceptance'

# Ensure IPv6 router advertisements are not accepted - Section 3.3.1
describe file ( '/etc/sysctl.d/99-sysctl.conf' ) do
    it { should be_l }
    it { should be_owned_by 'root' }
    it { should be_grouped_into 'root' }
end