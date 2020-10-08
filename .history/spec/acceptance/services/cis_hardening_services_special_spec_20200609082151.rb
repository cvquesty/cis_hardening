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
describe service('avahi-daemon') do
    it { should_not be_running }
end

# Ensure CUPS is not enabled - Section 2.2.4
describe service('cups') do
    it { should_not be_running }
end

# Ensure DHCP Server is not enabled - Section 2.2.5
describe service('dhcpd') do
    it { should_not running }
end

# Ensure LDAP Server is not enabled - Section 2.2.6
describe service('slapd') do
    it { should_not be_running }
end

# Ensure NFS and RPC are not enabled - Section 2.2.7
describe service('nfs') do
    it { should_not be_running }
end

describe service('nfs-server') do
    it { should_not be_running }
end

describe service('rpcbind') do
    it { should_not be_running }
end

# Ensure DNS Server is not enabled - Section 2.2.8
describe service('named') do
    it { should_not be_running }
end

# Ensure FTP Server is not enabled - Section 2.2.9
describe package('vsftpd') do
    it { should_not be_running }
end

# Ensure HTTP Server is not enabled - Section 2.2.10
describe service('httpd') do
    it { should_not be_running }
end

# Ensure IMAP and POP3 Server are not enabled - Section 2.2.11
describe service('dovecot') do
    it { should_not be_running }
end

# Ensure Samba is not enabled - Section 2.2.12
describe service('smb') do
    it { should_not be_running }
end

# Ensure HTTP Proxy Server is not enabled - Section 2.2.13
describe service('squid') do
    it { should_not be_running }
end

# Ensure SNMP Server is not enabled - Section 2.2.14
describe service('snmpd') do
    it { should_not be_running }
end

# Ensure MTA is configured for local-only mode - Section 2.2.15
describe file('/etc/postfix/main.cf') do
    it { should be_file }
    it { should be_owned_by 'root'}
end