require 'spec_helper'

describe 'cis_hardening::services::inetd' do
  on_supported_os.each do |os, os_facts|
    context "on #{os}" do
      let(:facts) { os_facts }

      # Check for default class
      it {
        is_expected.to contain_class('cis_hardening::services::inetd')
      

      # Ensure xinetd server is not enabled - Section 2.1.7
      it {
        is_expected.to contain_package('xinetd').with(
          'ensure'     => 'stopped',
        )
      }

      # Ensure manifest compiles with all dependencies
      it {
        is_expected.to compile.with_all_deps
      }
    end
  end
end
