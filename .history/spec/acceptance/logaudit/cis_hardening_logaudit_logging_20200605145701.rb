require 'spec_helper_acceptance'

# Ensure rsyslog service is enabled - Section 4.2.1.1
describe service('rsyslog') do
    it { should be_running }
    it { should be_enabled }

end

# Ensure logging is configured - Section 4.2.1.2
describe  file('/etc/rsyslog.conf') do
    it { should be_file}
end