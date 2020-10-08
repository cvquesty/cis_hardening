require 'spec_helper'

describe 'cis_hardening::auth' do
  on_supported_os.each do |os, os_facts|
    context "on #{os}" do
      let(:facts) { os_facts }

      # Check for default class
      it {
        is_expected.to contain_class('cis_hardening::auth')
      }

      # Check for all includes in the auth.pp
      it {
        is_expected.to contain_class('cis_hardening::auth::accounts')
      }
      it {
        is_expected.to contain_class('cis_hardening::auth::cron')
      }
      it {
        is_expected.to contain_class('cis_hardening::auth::pam')
      }
      it {
        is_expected.to contain_class('cis_hardening::auth::ssh')
      }
      it {
        is_expected.to contain_class('cis_hardening::auth::su')
      }

      # Ensure manifest compiles with all dependencies
      it {
        is_expected.to compile.with_all_deps
      }
    end
  end
end
