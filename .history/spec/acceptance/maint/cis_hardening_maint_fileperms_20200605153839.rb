require 'spec_helper_acceptance'

# Ensure permissions on /etc/passwd are configured - Section 6.1.2
describe file('/etc/passwd') do
    it { should be_file }
    it { should }
end