# frozen_string_literal: true

require 'spec_helper'

describe 'cis_hardening::setup::sudo' do
  on_supported_os.each do |os, os_facts|
    context "on #{os}" do
      let(:facts) { os_facts }

        # Section 1.3 - Configure sudo
        it do


      it { is_expected.to compile }
    end
  end
end
