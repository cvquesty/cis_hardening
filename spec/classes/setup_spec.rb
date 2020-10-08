require 'spec_helper'

describe 'cis_hardening::setup' do
  on_supported_os.each do |os, os_facts|
    context "on #{os}" do
      let(:facts) { os_facts }

      # Check for default class
      it { is_expected.to contain_class('cis_hardening::setup') }

      # Check for all includes in the setup.pp
      it { is_expected.to contain_class('cis_hardening::setup::updates') }
      it { is_expected.to contain_class('cis_hardening::setup::secboot') }
      it { is_expected.to contain_class('cis_hardening::setup::prochardening') }
      it { is_expected.to contain_class('cis_hardening::setup::fim') }
      it { is_expected.to contain_class('cis_hardening::setup::filesystem') }
      it { is_expected.to contain_class('cis_hardening::setup::banners') }
      it { is_expected.to contain_class('cis_hardening::setup::accessctl') }

      # Ensure manifest compiles with all dependencies
      it { is_expected.to compile.with_all_deps }
    end
  end
end
