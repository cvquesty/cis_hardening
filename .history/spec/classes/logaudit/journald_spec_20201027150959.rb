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
        is_expected.to contain_file_line('')
      }

      # Ensure manifest compiles with all dependencies
      it { is_expected.to compile }
    end
  end
end
