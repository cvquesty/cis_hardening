require 'spec_helper_acceptance'

# Ensure message of the day (MOTD) is properly configured - Section 1.7.1.1,
# Ensure permisisons on /etc/motd are configured - Section 1.7.1.4
describe file('/etc/motd') do
    it { should be_file }
    it { should be_owned_by 'root' }
    it { should be_grouped_into 'root' }
    it { should be_mode 644 }
    its(:content) { should }
end