require 'spec_helper'

describe 'cis_hardening::setup::fim' do
  on_supported_os.each do |os, os_facts|
    context "on #{os}" do
      let(:facts) { os_facts }

      # Check for default class
      it { is_expected.to contain_class('cis_hardening::setup::fim')}

      # Ensure AIDE is installed - Section 1.3.1
      it { is_expected.to contain_package('aide').with(
        'ensure' => 'present',
      )}

      # Initialize AIDE
      it { is_expected.to contain_exec('aideinit').with(
        'path'    => '/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin',
        'command' => 'aide --init',
        'unless'  => 'test -f /var/lib/aide/aide.db.new.gz',
      ).that_requires('Package[aide]')}

      it { is_expected.to contain_exec('bkup_aide').with(
        'path'    => '/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin',
        'command' => 'mv /var/lib/aide/aide.db.new.gz /var/lib/aide/aide.db.gz',
        'onlyif'  => 'test -f /var/lib/aide/aide.db.new.gz',
        'unless'  => 'test -f /var/lib/aide/aide.db.gz',        
      ).that_requires('Exec[aideinit]')}

      it { is_expected.to contain_cron('aide').with(
        'command' => '/usr/sbin/aide --check',
        'user'    => 'root',
        'hour'    => 5,
        'minute'  => 0,
      )}

      # Ensure the manifest compiles with all dependencies
      it { is_expected.to compile.with_all_deps }
    end
  end
end
