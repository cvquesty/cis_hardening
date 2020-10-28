require 'spec_helper'

describe 'cis_hardening::network::netparams' do
  on_supported_os.each do |os, os_facts|
    context "on #{os}" do
      let(:facts) { os_facts }

      # Check for default class
      it {
        is_expected.to contain_class('cis_hardening::network::netparams')
      }

      # Ensure Restart sysctl section to enact changes exists
      it {
        is_expected.to contain_exec('restart_sysctl').with(
          'path'    => '/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin',
          'command' => '/sbin/sysctl -p',
        )
      }

      # Ensure IP Forwarding is disabled - Section 3.2.1
      it {
        is_expected.to contain_file_line('ipforward_disable').with(
          'ensure' => 'present',
          'path'   => '/etc/sysctl.d/99-sysctl.conf',
          'line'   => 'net.ipv4.ip_forward = 0',
        ).that_notifies('Exec[restart_sysctl]')
      }

      # Ensure packet redirect sending is disabled - Section 3.2.2
      it {
        is_expected.to contain_file_line('redirect_all_disable').with(
          'ensure' => 'present',
          'path'   => '/etc/sysctl.d/99-sysctl.conf',
          'line'   => 'net.ipv4.conf.all.send_redirects = 0',
        ).that_notifies('Exec[restart_sysctl]')
      }

      it {
        is_expected.to contain_file_line('redirect_default_disable').with(
          'ensure' => 'present',
          'path'   => '/etc/sysctl.d/99-sysctl.conf',
          'line'   => 'net.ipv4.conf.default.send_redirects = 0',
        ).that_notifies('Exec[restart_sysctl]')
      }

      # Network Parameters for Host and Router - Section 3.3
      # Ensure source routed packets are not accepted - Section 3.3.1
      it {
        is_expected.to contain_file_line('source_route_all').with(
          'ensure' => 'present',
          'path'   => '/etc/sysctl.d/99-sysctl.conf',
          'line'   => 'net.ipv4.conf.all.accept_source_route = 0',
        ).that_notifies('Exec[restart_sysctl]')
      }

      it {
        is_expected.to contain_file_line('source_route_default').with(
          'ensure' => 'present',
          'path'   => '/etc/sysctl.d/99-sysctl.conf',
          'line'   => 'net.ipv4.conf.default.accept_source_route = 0',
        ).that_notifies('Exec[restart_sysctl]')
      }

      # Ensure ICMP redirects are not accepted - Section 3.3.2
      it {
        is_expected.to contain_file_line('icmp_redirects_all').with(
          'ensure' => 'present',
          'path'   => '/etc/sysctl.d/99-sysctl.conf',
          'line'   => 'net.ipv4.conf.all.accept_redirects = 0',
        ).that_notifies('Exec[restart_sysctl]')
      }

      it {
        is_expected.to contain_file_line('icmp_redirects_default').with(
          'ensure' => 'present',
          'path'   => '/etc/sysctl.d/99-sysctl.conf',
          'line'   => 'net.ipv4.conf.default.accept_redirects = 0',
        ).that_notifies('Exec[restart_sysctl]')
      }

      # Ensure secure ICMP redirects are not accepted - Section 3.3.3
      it {
        is_expected.to contain_file_line('icmp_redirects_all_secure').with(
          'ensure' => 'present',
          'path'   => '/etc/sysctl.d/99-sysctl.conf',
          'line'   => 'net.ipv4.conf.all.secure_redirects = 0',
        ).that_notifies('Exec[restart_sysctl]')
      }

      it {
        is_expected.to contain_file_line('icmp_redirects_default_secure').with(
          'ensure' => 'present',
          'path'   => '/etc/sysctl.d/99-sysctl.conf',
          'line'   => 'net.ipv4.conf.default.secure_redirects = 0',
        ).that_notifies('Exec[restart_sysctl]')
      }

      # Ensure suspicious packets are logged - Section 3.3.4
      it {
        is_expected.to contain_file_line('log_suspicious_all').with(
          'ensure' => 'present',
          'path'   => '/etc/sysctl.d/99-sysctl.conf',
          'line'   => 'net.ipv4.conf.all.log_martians = 1',
        ).that_notifies('Exec[restart_sysctl]')
      }

      it {
        is_expected.to contain_file_line('log_suspicious_default').with(
          'ensure' => 'present',
          'path'   => '/etc/sysctl.d/99-sysctl.conf',
          'line'   => 'net.ipv4.conf.default.log_martians = 1',
        ).that_notifies('Exec[restart_sysctl]')
      }

      # Ensure broadcast ICMP requests are ignored - Section 3.3.5
      it {
        is_expected.to contain_file_line('ignore_broadcasts').with(
          'ensure' => 'present',
          'path'   => '/etc/sysctl.d/99-sysctl.conf',
          'line'   => 'net.ipv4.icmp_echo_ignore_broadcasts = 1',
        ).that_notifies('Exec[restart_sysctl]')
      }

      # Ensure bogus ICMP responses are ignored - Section 3.3.6
      it {
        is_expected.to contain_file_line('ignore_bogus_icmp_errors').with(
          'ensure' => 'present',
          'path'   => '/etc/sysctl.d/99-sysctl.conf',
          'line'   => 'net.ipv4.icmp_ignore_bogus_error_responses = 1',
        ).that_notifies('Exec[restart_sysctl]')
      }

      # Ensure reverse path filtering is enabled - Section 3.3.7
      it {
        is_expected.to contain_file_line('reverse_path_filter_all').with(
          'ensure' => 'present',
          'path'   => '/etc/sysctl.d/99-sysctl.conf',
          'line'   => 'net.ipv4.conf.all.rp_filter = 1',
        ).that_notifies('Exec[restart_sysctl]')
      }

      it {
        is_expected.to contain_file_line('reverse_path_filter_default').with(
          'ensure' => 'present',
          'path'   => '/etc/sysctl.d/99-sysctl.conf',
          'line'   => 'net.ipv4.conf.default.rp_filter = 1',
        ).that_notifies('Exec[restart_sysctl]')
      }

      # Ensure TCP SYN Cookies is enabled - Section 3.3.8
      it {
        is_expected.to contain_file_line('tcp_syncookies').with(
          'ensure' => 'present',
          'path'   => '/etc/sysctl.d/99-sysctl.conf',
          'line'   => 'net.ipv4.tcp_syncookies = 1',
        ).that_notifies('Exec[restart_sysctl]')
      }

      # Ensure IPv6 router advertisements are not accepted - Section 3.3.9
      it {
        is_expected.to contain_file_line('net_ipv6_all_accept_ra').with(
          'ensure' => 'present',
          'path'   => '/etc/sysctl.d/99-sysctl.conf',
          'line'   => 
        )
      }

      # Ensure it compiles with all dependencies
      it {
        is_expected.to compile.with_all_deps
      }
    end
  end
end
