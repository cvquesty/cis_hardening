# frozen_string_literal: true

require 'spec_helper'

describe 'cis_hardening::setup::sudo' do
  on_supported_os.each do |os, os_facts|
    context "on #{os}" do
      let(:facts) { os_facts }

        # Section 1.3 - Configure sudo

        # Ensure sudo is installed - Section 1.3.1
        it {
          is_expected.to contain_package('sudo').with(
            'ensure' => 'installed',
          )
        }

        # Ensure sudo commands use pty - Section 1.3.2
        it {
          is_expected.to contain_file('/etc/sudoers.d/cis_sudoers_defaults.conf').with(
            'ensure' => 'present',
            'owner'  => 'root',
            'group'  => 'root',
            'mode'   => '0440',
          )
        }

        it {
          is_expected.to contain_file_line('defaults_pty').with(
            'ensure'  => 'present',
            'path    => '/etc/sudoers.d/cis_sudoers_defaults.conf',
      line    => 'Defaults use_pty',
          )
        }

        


      it { is_expected.to compile }
    end
  end
end
