# frozen_string_literal: true

require 'spec_helper'

describe 'cis_hardening::logaudit::journald' do
  on_supported_os.each do |os, os_facts|
    context "on #{os}" do
      let(:facts) { os_facts }

      # Check for default class
      it { is_expected.to contain_class('cis_hardening::logaudit::journald') }

      # Ensure journald is configured to send logs to rsyslog - Section 4.2.2.1
      it {
        is_expected.to contain_file_line('journald_to_rsyslog').with(
          'ensure' => 'present',
          'path'   => '/etc/systemd/journald.conf',
          'line'   => 'ForwardToSyslog=yes',
          'match'  => '^ForwardToSyslog\=',
        )
      }

      # Ensure journald is configured to compress large log files - Section 4.2.2.2
      it {
        is_expected.to contain_file_line('journald_compress').with(
          'ensure' => ''
        )
      }

      # Ensure manifest compiles with all dependencies
      it { is_expected.to compile }
    end
  end
end
