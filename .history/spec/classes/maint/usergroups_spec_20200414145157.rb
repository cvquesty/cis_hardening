require 'spec_helper'

describe 'cis_hardening::maint::usergroups' do
  on_supported_os.each do |os, os_facts|
    context "on #{os}" do
      let(:facts) { os_facts }

      # Check fr default class
      it { is_expected.to contain_class('cis_hardening::maint::usergroups')}

      # Ensure manifest compiles with all dependencies
      it { is_expected.to compile.with_all_deps }
    end
  end
end
