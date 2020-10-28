require 'spec_helper'

describe 'cis_hardening::setup::accessctl' do
  on_supported_os.each do |os, os_facts|
    context "on #{os}" do
      let(:facts) { os_facts }

      # Check for default class
      it {
        is_expected.to contain_class('cis_hardening::setup::accessctl')
      }

      # Configure SELinux - Section 1.7.1
      # Ensure SELinux is installed - Section 1.7.1.1
      it {
        is_expected.to contain_package('libselinux').with(
          'ensure' => 'present',
        )
      }

      # Ensure SELinux is not disabled in bootloader configuration - Section 1.7.1.2
      it {
        is_expected.to contain_file_line('grub_selinux_default').with(
          'ensure' => 'present',
          'path'   => '/etc/default/grub',
          'line'   => 'GRUB_CMDLINE_LINUX_DEFAULT="quiet"',
          'match'  => '^GRUB_CMDLINE_LINUX_DEFAULT\=',
        )
      }

      it {
        is_expected.to contain_file_line('grub_selinux').with(
          'ensure' => 'present',
          'path'   => '/etc/default/grub',
          'line'   => 'GRUB_CMDLINE_LINUX="audit=1"',
          'match'  => '^GRUB_CMDLINE_LINUX\=',
        )
      }
      
      # Ensure SELINUX Policy is configured - Section 1.7.1.3
      it {
        is_expected.to contain_file_line('selinux_policy').with(
          'ensure' => 'present',
          'path'   => '/etc/selinux/config',
          'line'   => 'SELINUXTYPE=targeted',
          'match'  => '^SELINUXTYPE\=',
        )
      }

      # Ensure the SELinux mode is "enforcing" or "permisive - Section 1.7.1.4
      # Ensure the SELinux mode is "enforcing" - Section 1.7.1.5
      it {
        is_expected.to contain_file_line('selinux_state').with(
          'ensure' => 'present',
          'path'   => '/etc/selinux/config',
          'line'   => 'SELINUX=enforcing',
          'match'  => '^SELINUX\=',
        )
      }

      # Ensure no unconfined services exist - Section 1.7.1.6
      it {
        is_expected.to contain_exec('unconfined_services').with(
          'path'    => '/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin',
          'command => 'logger -p crit "Some unconfined services are running"',
          'onlyif  => 'test `ps -eZ | grep unconfined_service_t`',
        )
      }

      # Ensure SETroubleshoot is not installed - Section 1.6.1.4
      it {
        is_expected.to contain_package('setroubleshoot').with(
          'ensure' => 'absent',
        )
      }

      # Ensure MCS Translation Service is not installed - Section 1.6.1.5
      it {
        is_expected.to contain_package('mcstrans').with(
          'ensure' => 'absent',
        )
      }

      # Ensure it compiles with all dependencies
      it {
        is_expected.to compile.with_all_deps
      }
    end
  end
end
