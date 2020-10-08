require 'spec_helper'

describe 'cis_hardening::network::ipv6' do
  on_supported_os.each do |os, os_facts|
    context "on #{os}" do
      let(:facts) { os_facts }

      # Check for default class
      it {
        is_expected.to contain_class('cis_hardening::network::ipv6')
      }

      # Ensure restart method for sysctl ipv6 controls exists
      it {
        is_expected.to contain_exec('restart_ipv6_sysctl').with(
          'path'    => '/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin',
          'command' => '/sbin/sysctl -p',
        )
      }

      # Ensure that IPv6 router advertisements are not accepted - Section 3.3.1
      it {
        is_expected.to contain_file_line('ipv6_accept_ra_all').with(
          'ensure' => 'present',
          'path'   => '/etc/sysctl.d/99-sysctl.conf',
          'line'   => 'net.ipv6.conf.all.accept_ra = 0',
        ).that_notifies('Exec[restart_ipv6_sysctl]')
      }

      it {
        is_expected.to contain_file_line('ipv6_acept_ra_default').with(
          'ensure' => 'present',
          'path'   => '/etc/sysctl.d/99-sysctl.conf',
          'line'   => 'net.ipv6.conf.default.accept_ra = 0',
        ).that_notifies('Exec[restart_ipv6_sysctl]')
      }

      # Ensure that IPv6 redirets are not accepted - Section 3.3.2
      it {
        is_expected.to contain_file_line('ipv6_accept_redirects_all').with(
          'ensure' => 'present',
          'path'   => '/etc/sysctl.d/99-sysctl.conf',
          'line'   => 'net.ipv6.conf.all.accept_redirects = 0',
        ).that_notifies('Exec[restart_ipv6_sysctl]')
      }

      it {
        is_expected.to contain_file_line('ipv6_accept_redirects_default').with(
          'ensure' => 'present',
          'path'   => '/etc/sysctl.d/99-sysctl.conf',
          'line'   => 'net.ipv6.conf.default.accept_redirects = 0',
        ).that_notifies('Exec[restart_ipv6_sysctl]')
      }

      # Ensure it compiles with all dependencies
      it {
        is_expected.to compile.with_all_deps
      }
    end
  end
end
