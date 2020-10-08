require 'spec_helper_acceptance'

# Ensure Chargen Services are not enabled - Section 2.1.1
describe service('chargen-dgram') do
    it { should_not be_enabled }
    it { should_not be_running}
end

describe service('chargen-stream') do
    it { should_not be_enabled }
    it { should_not be_running }
end

# Ensure Daytime services are not enabled - Section 2.1.2
describe service('daytime-dgram') do
    it { should_not be_enabled }
    it { should}
end