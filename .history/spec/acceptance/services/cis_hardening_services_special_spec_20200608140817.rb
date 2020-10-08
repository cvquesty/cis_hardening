require 'spec_helper_acceptance'

# Ensure time synchronization is in use - Section 2.2.1.1
describe package('ntp') do
    it { }
end