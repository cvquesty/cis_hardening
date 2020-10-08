require 'spec_helper_acceptance'

# Ensure time synchronization is in use - Section 2.2.1.1
describe package('ntp') do
    it { should be_installed }
end

describe package('chrony') do
    it { should be_installed }
end

# Ensure ntp is configured - Section 2.2.1.2
describe file('/etc/ntp.conf') do
    it { should be}
end