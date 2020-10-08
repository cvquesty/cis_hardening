require 'spec_helper'

describe 'cis_hardening::services::inetd' do
  on_supported_os.each do |os, os_facts|
    context "on #{os}" do
      let(:facts) { os_facts }

      # Check for default class
      it {
        is_expected.to contain_class('cis_hardening::services::inetd')
      }

      # Ensure Chargen Services are not enabled - Section 2.1.1
      it {
        is_expected.to contain_service('chargen-dgram').with(
          'ensure'     => 'stopped',
          'enable'     => false,
          'hasstatus'  => true,
          'hasrestart' => true,
        )
      }

      it {
        is_expected.to contain_service('chargen-stream').with(
          'ensure'     => 'stopped',
          'enable'     => false,
          'hasstatus'  => true,
          'hasrestart' => true,
        )
      }

      # Ensure Daytime services are not enabled - Section 2.1.2
      it {
        is_expected.to contain_service('daytime-dgram').with(
          'ensure'     => 'stopped',
          'enable'     => false,
          'hasstatus'  => true,
          'hasrestart' => true,
        )
      }

      it {
        is_expected.to contain_service('daytime-stream').with(
          'ensure'     => 'stopped',
          'enable'     => false,
          'hasstatus'  => true,
          'hasrestart' => true,
        )
      }

      # Ensure discard services are not enabled - Section 2.1.3
      it {
        is_expected.to contain_service('discard-dgram').with(
          'ensure'     => 'stopped',
          'enable'     => false,
          'hasstatus'  => true,
          'hasrestart' => true,
        )
      }

      it {
        is_expected.to contain_service('discard-stream').with(
          'ensure'     => 'stopped',
          'enable'     => false,
          'hasstatus'  => true,
          'hasrestart' => true,
        )
      }

      # Ensure echo services are not enabled - Section 2.1.4
      it {
        is_expected.to contain_service('echo-dgram').with(
          'ensure'     => 'stopped',
          'enable'     => false,
          'hasstatus'  => true,
          'hasrestart' => true,
        )
      }
        
      it {
        is_expected.to contain_service('echo-stream').with(
          'ensure'     => 'stopped',
          'enable'     => false,
          'hasstatus'  => true,
          'hasrestart' => true,
        )
      }

      # Ensure time services are not enabled - Section 2.1.5
      it {
        is_expected.to contain_service('time-dgram').with(
          'ensure'     => 'stopped',
          'enable'     => false,
          'hasstatus'  => true,
          'hasrestart' => true,
        )
      }
        
      it {
        is_expected.to contain_service('time-stream').with(
          'ensure'     => 'stopped',
          'enable'     => false,
          'hasstatus'  => true,
          'hasrestart' => true,
        )
      }

      # Ensure tftp server is not enabled - Section 2.1.6
      it {
        is_expected.to contain_service('tftp').with(
          'ensure'     => 'stopped',
          'enable'     => false,
          'hasstatus'  => true,
          'hasrestart' => true,
        )
      }

      # Ensure xinetd server is not enabled - Section 2.1.7
      it {
        is_expected.to contain_service('xinetd').with(
          'ensure'     => 'stopped',
          'enable'     => false,
          'hasstatus'  => true,
          'hasrestart' => true,
        )
      }

      # Ensure manifest compiles with all dependencies
      it {
        is_expected.to compile.with_all_deps
      }
    end
  end
end
