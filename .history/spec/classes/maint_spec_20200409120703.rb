require 'spec_helper'

describe 'cis_hardening::maint' do
  on_supported_os.each do |os, os_facts|
    context "on #{os}" do
      let(:facts) { os_facts }

      # Check for default class
      it { is_expected.to contain_class('cis_hardening::maint')}

      # Check for all includes in the maint.pp
      it { is_expected.to contain_class('cis_hardening::maint::fileperms')}
      it { is_expected.to contain_class('cis_hardening::maint::usergroups')}

      # Ensure manifest compiles with all dependencies
      it { is_expected.to compile.with_all_deps }
    end
  end
end
