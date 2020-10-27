require 'spec_helper'

describe 'cis_hardening::maint::usergroups' do
  on_supported_os.each do |os, os_facts|
    context "on #{os}" do
      let(:facts) { os_facts }

      # Check fr default class
      it {
        is_expected.to contain_class('cis_hardening::maint::usergroups')
      }

      # Ensure accounts in /etc/passwd use shadowed passwords - Section 6.2.1
      it {
        is_expected.to contain_exec('shadowed_passwords_check').with(
          'path'    => '/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin',
          'command' => "sed -e 's/^\([a-zA-Z0-9_]*\):[^:]*:/\1:x:/' -i /etc/passwd",
          'onlyif'  => "test ! `awk -F: '($2 != "x" )' /etc/passwd`",
        )
      }

      # Ensure /etc/shadow password fields are not empty - Section 6.2.2
      it {
        is_expected.to contain_exec()
      }

      # Ensure manifest compiles with all dependencies
      it {
        is_expected.to compile.with_all_deps
      }
    end
  end
end
