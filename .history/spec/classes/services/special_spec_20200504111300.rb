require 'spec_helper'

describe 'cis_hardening::services::special' do
  on_supported_os.each do |os, os_facts|
    context "on #{os}" do
      let(:facts) { os_facts }

      # Check for main class
      it { is_expected.to contain_class('cis_hardening::services::special')}
        
      # Ensure Time Synchronization is in use - Section 2.2.1.1
      it { is_expected.to contain_package('ntp').with(
        'ensure' => 'present',
      )}

      it { is_expected.to contain_package('chrony').with(
        'ensure' => 'present',
      )}

      # Ensure that ntp is configured - Section 2.2.1.2
      it { is_expected.to contain_file('/etc/ntp.conf').with(
        'ensure'  => 'present',
        'owner'   => 'root',
        'group'   => 'root',
        'mode'    => '0644',
        'source'  => 'puppet:///modules/cis_hardening/ntp_conf',
      ).that_requires('Package[ntp]')}

      it { is_expected.to contain_file('/etc/sysconfig/ntpd').with(
        'ensure'  => 'present',
        'owner'   => 'root',
        'group'   => 'root',
        'mode'    => '0644',
        'source'  => 'puppet:///modules/cis_hardening/etc_sysconfig_ntpd',
      ).that_requires('File[/etc/ntp.conf]')}

      it { is_expected.to contain_file_line('ntp_options').with(
        'ensure' => 'present',
        'path'   => '/usr/lib/systemd/system/ntpd.service',
        'line'   => 'ExecStart=/usr/sbin/ntpd -u ntp:ntp $OPTIONS',
        'match'  => '^ExecStart=/usr/sbin/ntpd -u ntp:ntp $OPTIONS',
      )}

      # Ensure Chrony is Configured - Section 2.2.1.3
      it { is_expected.to contain_file('/etc/chrony.conf').with(
        'ensure' => 'present',
        'owner'  => 'root',
        'group'  => 'root',
        'mode'   => '0644',
        'source' => 'puppet:///modules/cis_hardening/etc_chrony_conf',
      )}

      it { is_expected.to contain_file_line('chrony_settings').with(
        'ensure' => 'present',
        'path'   => '/etc/sysconfig/chronyd',
        'line'   => 'OPTIONS="-u chrony"',
        'match'  => '^OPTIONS="-u"',
      )}

        # Ensure X Window System is not installed - Section 2.2.2
        it { is_expected.to contain_package('xorg-x11-server-Xorg').with(
        'ensure' => 'absent',
        )}
        
        # Ensure Avahi Server is not enabled - Section 2.2.3
        it { is_expected.to contain_service('avahi-daemon').with(
          'enable' => false,
        )}

        # Ensure CUPS is not enabled - Section 2.2.4
        it { is_expected.to contain_service('cups').with(
          'enable' => false,
        )}

        # Ensure DHCP Server is not enabled - Section 2.2.5
        it { is_expected.to contain_service('dhcpd').with(
          'enable' => false,
        )}

        # Ensure LDAP Server is not enabled - Section 2.2.6
        it { is_expected.to contain_service('slapd').with(
          'enable' => false,
        )}

        # Ensure NFS and RPC are not enabled - Section 2.2.7
        it { is_expected.to contain_service('nfs').with(
          'enable' => false,
        )}

        it { is_expected.to contain_service('nfs-server').with(
          'enable' => false,
        )}

        it { is_expected.to contain_service('rpcbind').with(
          'enable' => false,
        )}

        # Ensure DNS Server is not enabled - Section 2.2.8
        it { is_expected.to contain_service('named').with(
          'enable' => false,
        )}

        # Ensure FTP Server is not enabled - Section 2.2.9
        it { is_expected.to contain_service('vsftpd').with(
          'enable' => false,
        )}

        # Ensure HTTP Server is not enabled - Section 2.2.10
        it { is_expected.to contain_service('httpd').with(
          'enable' => false,
        )}

        # Ensure IMAP and POP3 Server are not enabled - Section 2.2.11
        it { is_expected.to contain_service('dovecot').with(
          'enable' => false,
        )}

        # Ensure Samba is not enabled - Section 2.2.12
        it { is_expected.to contain_service('smb').with(
          'enable' => false,
        )}

        # Ensure HTTP Proxy Server is not enabled - Section 2.2.13
        it { is_expected.to contain_service('squid').with(
          'enable' => false,
        )}

        # Ensure SNMP Server is not enabled - Section 2.2.14
        it { is_expected.to contain_service('snmpd').with(
          'enable' => false,
        )}

        # Ensure MTA is configured for local-only mode - Section 2.2.15
        it { is_expected.to contain_file_line('smptp_local_only_mode').with(
          'ensure' => 'present',
          'path'   => '/etc/postfix/main.cf',
          'line'   => 'inet_interfaces = loopback-only',
          'match'  => '^inet_interfaces\ =',
        )}

        # Ensure NIS Server is not enabled - Section 2.2.16
        it { is_expected.to contain_service('ypserv').with(
          'enable' => false,
        )}

        # Ensure RSH Server is not enabled - Section 2.2.17
        it { is_expected.to contain_service('rsh.socket').with(
          'enable' => false,
        )}

        it { is_expected.to contain_service('rlogin.socket').with(
          'enable' => false,
        )}

        it { is_expected.to contain_service('rexec.socket').with(
          'enable' => false,
        )}

        # Ensure Telnet Server is not enabled - Section 2.2.18
        it { is_expected.to contain_service('telnet.socket').with(
          'enable' => false,
        )}

        # Ensure tftp Server is not enabled - Section 2.2.19
        it { is_expected.to contain_service('tftp.socket').with(
          'enable' => false,
        )}

        # Ensure Rsync Service is not enabled - Section 2.2.20
        it { is_expected.to contain_service('rsyncd').with(
          'enable' => false,
        )}

        # Ensure Talk server is not enabled - Section 2.2.21
        it { is_expected.to contain_service('ntalk').with(
          'enable' => false,
        )}




      # Ensure manifest compiles with all dependencies
      it { is_expected.to compile.with_all_deps }
    end
  end
end
