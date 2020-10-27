# frozen_string_literal: true

require 'spec_helper'

describe 'cis_hardening::logaudit::journald' do
  on_supported_os.each do |os, os_facts|
    context "on #{os}" do
      let(:facts) { os_facts }

      

      # Ensure manifest compiles with all dependencies
      it { is_expected.to compile }
    end
  end
end
