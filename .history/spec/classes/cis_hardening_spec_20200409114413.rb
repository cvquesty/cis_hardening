require 'spec_helper'

describe 'cis_hardening' do
  on_supported_os.each do |os, os_facts|
    context "on #{os}" do
      let(:facts) { os_facts }
      # Check for default class
      it { is_expected.to contain_class('cis_hardening')}

      # Check for all includes in the init.pp
      it { is_expected.to contain_class('cis_hardening::auth')}
      it { is_expected.to contain_class('cis_hardening::logaudit')}
      it { is_expected.to contain_class('cis_hardening::maint')}
      it { is_expected.to contain_class('cis_hardening::network')}
      it { is_expected.to contain_class('cis_hardening::services')}
      it { is_expected.to contain_class('cis_hardening::setup')}

      # Ensure manifest compiles with all dependencies
      it { is_expected.to compile.with_all_deps }
    end
  end
end
