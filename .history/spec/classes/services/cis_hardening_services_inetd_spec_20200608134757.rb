require 'spec_helper_acceptance'

# Ensure Chargen Services are not enabled - Section 2.1.1
describe service('chargen-dgram') do
    it { should_not be_enabled }
    it { should_not be_running}
end

