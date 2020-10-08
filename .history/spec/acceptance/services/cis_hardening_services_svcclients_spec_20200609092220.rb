require 'spec_helper_acceptance'

# Ensure NIS CLient is not installed - Section 2.3.1
describe package('ypbind') do
    it { should_not be_installed }
end

# Ensure rsh Client is not installed - Section 2.3.2
describe package('rsh') do
    it { should_not be_installed}
end

# Ensure talk client is not installed - Section 2.3.3
describe package('talk') do
    it { should_not be_installed }
end

# Ensure telnet client is not installed - Section 2.3.4
describe package('telnet') do
    
end