require 'spec_helper_acceptance'

# Ensure DCCP is disabled - Section 3.5.1
describe file('/etc/modprobe.d/CIS.conf') do
    it { should be_file}
end