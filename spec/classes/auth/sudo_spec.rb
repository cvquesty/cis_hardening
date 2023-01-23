# frozen_string_literal: true

require 'spec_helper'

describe 'cis_hardening::auth::sudo' do
  on_supported_os.each do |os, os_facts|
    context "on #{os}" do
      let(:facts) { os_facts }

      # Check for the default class
      it {
        is_expected.to contain_class('cis_hardening::auth::sudo')
      }

      # Section 5.2 - Configure sudo

      # Ensure sudo is installed - Section 5.2.1
      it {
        is_expected.to contain_package('sudo').with(
          'ensure' => 'installed',
        )
      }

      # Ensure sudo commands use pty - Section 5.2.2
      it {
        is_expected.to contain_file('/etc/sudoers.d/cis_sudoers_defaults.conf').with(
          'ensure' => 'file',
          'owner'  => 'root',
          'group'  => 'root',
          'mode'   => '0440',
        )
      }

      it {
        is_expected.to contain_file_line('defaults_pty').with(
          'ensure'  => 'present',
          'path'    => '/etc/sudoers.d/cis_sudoers_defaults.conf',
          'line'    => 'Defaults use_pty',
        ).that_requires('File[/etc/sudoers.d/cis_sudoers_defaults.conf]')
      }

      # Ensure sudo log file exists - Section 5.2.3
      it {
        is_expected.to contain_file_line('defaults_sudo_logfile').with(
          'ensure' => 'present',
          'path'   => '/etc/sudoers.d/cis_sudoers_defaults.conf',
          'line'   => 'Defaults logfile="/var/log/sudo.log"',
        ).that_requires('File[/etc/sudoers.d/cis_sudoers_defaults.conf]')
      }

      # Ensure manifest compiles with all dependencies
      it {
        is_expected.to compile.with_all_deps
      }
    end
  end
end
