require 'spec_helper'

describe 'cis_hardening::setup::prochardening' do
  on_supported_os.each do |os, os_facts|
    context "on #{os}" do
      let(:facts) { os_facts }

      # Check for default class
      it {
        is_expected.to contain_class('cis_hardening::setup::prochardening')
      }
      # Section 1.6 - Additional Process Hardening

      # Ensure Restart sysctl for prochardening items
      it {
        is_expected.to contain_exec('restart_prochardening_sysctl').with(
          'path'    => '/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin',
          'command' => '/sbin/sysctl -p',
        )
      }

      # Ensure Core Dumps are restricted - Section 1.6.1
      it {
        is_expected.to contain_file('/etc/security/limits.d/cis_coredumps.conf').with(
          ensure  => 'present',
          owner   => 'root',
          group   => 'root',
          mode    => '0644',
      content => '* hard core 0',
        )
      }

      it {
        is_expected.to contain_file_line('fs_dumpable').with(
          'ensure' => 'present',
          'path'   => '/etc/sysctl.d/99-sysctl.conf',
          'line'   => 'fs.suid_dumpable = 0',
        ).that_notifies('Exec[restart_prochardening_sysctl]')
      }

      # Ensure Address space layout randomization - Section 1.5.3
      it {
        is_expected.to contain_file_line('randomize_va_space').with(
          'ensure' => 'present',
          'path'   => '/etc/sysctl.d/99-sysctl.conf',
          'line'   => 'kernel.randomize_va_space = 2',
        ).that_notifies('Exec[restart_prochardening_sysctl]')
      }

      # Ensure prelink is disabled - Section 1.5.3
      it {
        is_expected.to contain_package('prelink').with(
          'ensure' => 'absent',
        )
      }

      # Ensure manifest compiles with all dependencies
      it {
        is_expected.to compile.with_all_deps
      }
    end
  end
end
