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
    it { should_not be_running }
end

describe service('daytime-stream') do
    it { should_not be_enabled }
    it { should_not be_running }
end

# Ensure discard services are not enabled - Section 2.1.3
describe service('discard-dgram') do
    it { should_not be_enabled }
    it { should_not be_running }
end

describe service('discard-stream') do
    it { should_not be_enabled }
    it { should_not be_running }
end

# Ensure echo services are not enabled - Section 2.1.4
describe service('echo-dgram') do
    it { should_not be_enabled }
    it { should_not be_running }
end

describe service('echo-stream') do
    it { should_not be_enabled }
    it { should_not be_running }
end

# Ensure time services are not enabled - Section 2.1.5
describe service('time-dgram') do
    it { should_not be_enabled }
    it { should_not be_running }
end

describe service('time-stream') do
    
end