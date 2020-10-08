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
    it { should be_file }
    it { should be_owned_by 'root' }
    it { should be_grouped_into 'root' }
    it { should be_mode 644 }
end

describe file('/etc/sysconfig/ntpd') do
    it { should be_file }
    it { should be_owned_by 'root' }
    it { should be_grouped_into 'root' }
    it { should be_mode 644 }
end

describe file('/usr/lib/systemd/system/ntpd.service') do
    it { should be_file }
    it { should be_owned_by 'root' }
    it { should be_grouped_into 'root' }
    it { should be_mode 644 }
    its(:content) { should match /ExecStart=\/usr\/sbin\/ntpd -u ntp:ntp $OPTIONS/ }
end

# Ensure Chrony is configured - Section 2.2.1.3
describe file('/etc/chrony.conf') 