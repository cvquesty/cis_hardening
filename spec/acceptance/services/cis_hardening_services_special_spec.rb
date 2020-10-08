require 'spec_helper_acceptance'

describe 'Special Network Services' do
  # Ensure time synchronization is in use - Section 2.2.1.1
  describe package('ntp') do
    it { is_expected.to be_installed }
  end

  describe package('chrony') do
    it { is_expected.to be_installed }
  end

  # Ensure ntp is configured - Section 2.2.1.2
  describe file('/etc/ntp.conf') do
    it { is_expected.to be_file }
    it { is_expected.to be_owned_by 'root' }
    it { is_expected.to be_grouped_into 'root' }
    it { is_expected.to be_mode 0o0644 }
  end

  describe file('/etc/sysconfig/ntpd') do
    it { is_expected.to be_file }
    it { is_expected.to be_owned_by 'root' }
    it { is_expected.to be_grouped_into 'root' }
    it { is_expected.to be_mode 0o0644 }
  end

  describe file('/usr/lib/systemd/system/ntpd.service') do
    it { is_expected.to be_file }
    it { is_expected.to be_owned_by 'root' }
    it { is_expected.to be_grouped_into 'root' }
    it { is_expected.to be_mode 0o0644 }
    its(:content) { is_expected.to match %r{/ExecStart=\/usr\/sbin\/ntpd -u ntp:ntp \$OPTIONS/} }
  end

  # Ensure Chrony is configured - Section 2.2.1.3
  describe file('/etc/chrony.conf') do
    it { is_expected.to be_file }
    it { is_expected.to be_owned_by 'root' }
    it { is_expected.to be_grouped_into 'root' }
    it { is_expected.to be_mode 0o0644 }
  end

  describe file('/etc/sysconfig/chronyd') do
    it { is_expected.to be_file }
    it { is_expected.to be_owned_by 'root' }
    it { is_expected.to be_grouped_into 'root' }
    it { is_expected.to be_mode 0o0644 }
    its(:content) { is_expected.to match %r{/OPTIONS="-u chrony"/} }
  end

  # Ensure X Window System is not installed - Section 2.2.2
  describe package('xorg-x11-server-Xorg') do
    it { is_expected.not_to be_installed }
  end

  # Ensure Avahi Server is not enabled - Section 2.2.3
  describe service('avahi-daemon') do
    it { is_expected.not_to be_running }
  end

  # Ensure CUPS is not enabled - Section 2.2.4
  describe service('cups') do
    it { is_expected.not_to be_running }
  end

  # Ensure DHCP Server is not enabled - Section 2.2.5
  describe service('dhcpd') do
    it { is_expected.not_to be_running }
  end

  # Ensure LDAP Server is not enabled - Section 2.2.6
  describe service('slapd') do
    it { is_expected.not_to be_running }
  end

  # Ensure NFS and RPC are not enabled - Section 2.2.7
  describe service('nfs') do
    it { is_expected.not_to be_running }
  end

  describe service('nfs-server') do
    it { is_expected.not_to be_running }
  end

  describe service('rpcbind') do
    it { is_expected.not_to be_running }
  end

  # Ensure DNS Server is not enabled - Section 2.2.8
  describe service('named') do
    it { is_expected.not_to be_running }
  end

  # Ensure FTP Server is not enabled - Section 2.2.9
  describe service('vsftpd') do
    it { is_expected.not_to be_running }
  end

  # Ensure HTTP Server is not enabled - Section 2.2.10
  describe service('httpd') do
    it { is_expected.not_to be_running }
  end

  # Ensure IMAP and POP3 Server are not enabled - Section 2.2.11
  describe service('dovecot') do
    it { is_expected.not_to be_running }
  end

  # Ensure Samba is not enabled - Section 2.2.12
  describe service('smb') do
    it { is_expected.not_to be_running }
  end

  # Ensure HTTP Proxy Server is not enabled - Section 2.2.13
  describe service('squid') do
    it { is_expected.not_to be_running }
  end

  # Ensure SNMP Server is not enabled - Section 2.2.14
  describe service('snmpd') do
    it { is_expected.not_to be_running }
  end

  # Ensure MTA is configured for local-only mode - Section 2.2.15
  describe file('/etc/postfix/main.cf') do
    it { is_expected.to be_file }
    it { is_expected.to be_owned_by 'root' }
    it { is_expected.to be_grouped_into 'root' }
    it { is_expected.to be_mode 0o0644 }
    its(:content) { is_expected.to match %r{/inet_interfaces = loopback-only/} }
  end

  # Ensure NIS Server is not enabled - Section 2.2.16
  describe service('yserv') do
    it { is_expected.not_to be_running }
  end

  # Ensure RSH Server is not enabled - Section 2.2.17
  describe service('rsh.socket') do
    it { is_expected.not_to be_running }
  end

  describe service('rlogin.socket') do
    it { is_expected.not_to be_running }
  end

  describe service('rexec.socket') do
    it { is_expected.not_to be_running }
  end

  # Ensure Telnet Server is not enabled - Section 2.2.18
  describe service('telnet.socket') do
    it { is_expected.not_to be_running }
  end

  # Ensure tftp Server is not enabled - Section 2.2.19
  describe service('tftp.socket') do
    it { is_expected.not_to be_running }
  end

  # Ensure Rsync Service is not enabled - Section 2.2.20
  describe service('rsyncd') do
    it { is_expected.not_to be_running }
  end

  # Ensure Talk server is not enabled - Section 2.2.21
  describe service('ntalk') do
    it { is_expected.not_to be_running }
  end
end
