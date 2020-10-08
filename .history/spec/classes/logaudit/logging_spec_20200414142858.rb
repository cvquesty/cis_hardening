require 'spec_helper'

describe 'cis_hardening::logaudit::logging' do
  on_supported_os.each do |os, os_facts|
    context "on #{os}" do
      let(:facts) { os_facts }
      
      # Check for default class
      it { is_expected.to contain_class('cis_hardening::logaudit::logging')}

      # Ensure that Ensure rsyslog service is enabled - Section 4.2.1.1
      it { is_expected.to contain_service('rsyslog').with(
        'ensure'     => 'running',
        'enable'     => true,
        'hasstatus'  => true,
        'hasrestart' => true,
      ).that_requires('Package[rsyslog]')}

      # Ensure that Ensre rsyslog default file permissions configured - Section 4.2.1.3
      it { is_expected.to contain_file_line('logfile_perms').with(
        'ensure' => 'present',
        'path'   => '/etc/rsyslog.conf',
        'line'   => '$FileCreateMode 0640',
      )}

      # Ensure that Ensure rsyslog (or syslog-ng) is installed - Section 4.2.3
      it { is_expected.to contain_package('rsyslog').with(
        'ensure' => 'present',
      )}

      # Ensure that Ensure permissions on all logfiles are configured - Section 4.2.4
      it { is_expected.to contain_exec('set_logfile_permissions').with(
        'path'    => '/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin',
        'command' => 'find /var/log -type f -exec chmod g-wx,o-rwx {} +',
      )}

      # Ensure manifest compiles with all dependencies
      it { is_expected.to compile.with_all_deps }
    end
  end
end
