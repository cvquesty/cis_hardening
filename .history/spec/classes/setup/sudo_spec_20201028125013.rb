# frozen_string_literal: true

require 'spec_helper'

describe 'cis_hardening::setup::sudo' do
  on_supported_os.each do |os, os_facts|
    context "on #{os}" do
      let(:facts) { os_facts }

        # Section 1.3 - Configure sudo

        # Ensure sudo is installed - Section 1.3.1
        it {}

        # Ensure sudo commands use pty - Section 1.3.2
        it {
          is_expected.to contain_file('/etc/sudoers.d/cis_sudoers_defaults.conf').with(

          )
        }

        


      it { is_expected.to compile }
    end
  end
end
