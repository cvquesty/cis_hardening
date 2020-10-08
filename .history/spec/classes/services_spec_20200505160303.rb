require 'spec_helper'

describe 'cis_hardening::services' do
  on_supported_os.each do |os, os_facts|
    context "on #{os}" do
      let(:facts) { os_facts }

      # Check for default class
      it {
        is_expected.to contain_class('cis_hardening::services')
      }

      # Check for all includes in the services.pp
      it {
        is_expected.to contain_class('cis_hardening::services::inetd')
      }
      it {
        is_expected.to contain_class('cis_hardening::services::special')
      }
      it {
        is_expected.to contain_class('cis_hardening::services::svcclients')
      }
        
      # Ensure manifest compiles with all dependencies
      it {
        is_expected.to compile.with_all_deps
      }
    end
  end
end
