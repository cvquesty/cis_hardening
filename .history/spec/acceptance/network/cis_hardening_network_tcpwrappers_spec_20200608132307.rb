require 'spec_helper_acceptance'

# Verify TCP Wrappers are installed - Section 3.4.1
describe package('tcp_wrappers') do
    it { should_be installed }
end

# Ensure /etc/hosts.allow is configured - Section 3.4.2, 3.4.4
describe file