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
describe file('/etc/chrony.conf') do
    it { should be_file }
    it { should be_owned_by 'root' }
    it { should be_grouped_into 'root' }
    it { should be_mode 644 }
end

describe file('/etc/sysconfig/chronyd') do
    it { should be_file }
    it { should be_owned_by 'root' }
    it { should be_grouped_into 'root' }
    it { should be_mode 644 }
    its(:content) { should match /OPTIONS="-u chrony"/ }
end

# Ensure X Window System is not installed - Section 2.2.2
describe package('xorg-x11-server-Xorg') do
    it { should_not be_installed }
end

# Ensure Avahi Server is not enabled - Section 2.2.3
describe package('avahi-daemon') do
    it 
end
