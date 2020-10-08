require 'spec_helper_acceptance'

# Ensure permissions on /etc/passwd are configured - Section 6.1.2
describe file('/etc/passwd') do
    it { should be_file }
    it { should be_owned_by ('root') }
    it { should be_grouped_into('root') }
    it { should be_mode 644 }
end