require 'spec_helper_acceptance'

describe service('rsyslog') do
    it { should be_running }
    it { should be_enabled }
    
end