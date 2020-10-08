require 'spec_helper'

describe 'cis_hardening::logaudit' do
  on_supported_os.each do |os, os_facts|
    context "on #{os}" do
      let(:facts) { os_facts }

      # Check for default class
      it { is_expected.to contain_class('cis_hardening::logaudit') }

      # Check for all includes in the logaudit.pp
      it { is_expected.to contain_class('cis_hardening::logaudit::accounting') }
      it { is_expected.to contain_class('cis_hardening::logaudit::logging') }
      it { is_expected.to contain_class('cis_hardening::logaudit::logrotate') }

      # Ensure manifest compiles with all dependencies
      it { is_expected.to compile.with_all_deps }
    end
  end
end
