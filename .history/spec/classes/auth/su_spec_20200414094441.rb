require 'spec_helper'

describe 'cis_hardening::auth::su' do
  on_supported_os.each do |os, os_facts|
    context "on #{os}" do
      let(:facts) { os_facts }

      # Check for default class
      it { is_expected.to contain_class('cis_hardening::auth::su')}
        
      # Ensure that Ensure access to the su command is restricted - Section 5.6
      it { is_expected.to contain_file_line('su_setting').with(
        'path' => '/etc/pam.d/su',
        'line' => 'auth required pam_wheel.so use_uid',
      )}

      # Ensure manifest compiles with all dependencies
      it { is_expected.to compile.with_all_deps }
    end
  end
end
