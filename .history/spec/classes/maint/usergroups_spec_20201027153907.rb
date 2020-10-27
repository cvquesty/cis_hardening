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
        is_expected.to contain_exec('shadow_password_field_check').with(
          'path'    => '/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin',
          'command' => 'logger -p crit "Shadow Password Fields Empty. Check manually."',
          'onlyif'  => "test ! `awk -F: '($2 == "" )' /etc/shadow |wc -l` -gt 0",
        )
      }

      # Ensure the root account is the only UID 0 Account - Section 6.2.3
      it {
        is_expected.to contain_exec('only_one_uid0').with(
          'path'    => '/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin',
          'command' => 'logger -p crit "More than one user has a UID of 0"',
          'onlyif'  => "test ! `awk -F: '($3 == 0) { print $1 }' /etc/passwd |grep -v root`",
        )
      }

      # Ensure root PATH integrity - Section 6.2.4
      it {}

      # Ensure manifest compiles with all dependencies
      it {
        is_expected.to compile.with_all_deps
      }
    end
  end
end
