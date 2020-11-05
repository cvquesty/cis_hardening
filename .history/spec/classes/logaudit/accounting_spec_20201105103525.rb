require 'spec_helper'

describe 'cis_hardening::logaudit::accounting' do
  on_supported_os.each do |os, os_facts|
    context "on #{os}" do
      let(:facts) { os_facts }

      # Check for default class
      it { is_expected.to contain_class('cis_hardening::logaudit::accounting') }

      # Ensure Auditing is enabled - Section 4.1.1
      # Ensure that auditd is installed - Section 4.1.1.1
      it {
        is_expected.to contain_package('audit').with(
          'ensure' => 'present',
        )
      }

      it {
        is_expected.to contain_package('audit-libs').with(
          'ensure' => 'present',
        )
      }

      # Ensure auditd service is enabled and running - Section 4.1.1.2
      it {
        is_expected.to contain_service('auditd').with(
          'ensure'     => 'running',
          'enable'     => true,
          'hasstatus'  => true,
          'hasrestart' => true,
        ).that_requires('File[/etc/audit/audit.rules]')
      }

      it {
        is_expected.to contain_exec('restart_auditd').with(
          'path'    => '/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin',
          'command' => '/bin/systemctl restart auditd',
        ).that_requires('Package[audit]')
      }

      # Ensure that Ensure auditing for processes that start prior to auditd is enabled - Section 4.1.1.3
      it {
        is_expected.to contain_file_line('pre_auditd_settings').with(
          'ensure' => 'present',
          'path'   => '/etc/default/grub',
          'line'   => 'GRUB_CMDLINE_LINUX="audit=1"',
        ).that_requires('File[/etc/default/grub]')
      }

      it {
        is_expected.to contain_file('/etc/audit/audit.rules').with(
          'ensure' => 'present',
          'owner'  => 'root',
          'group'  => 'root',
          'mode'   => '0640',
        ).that_requires('Package[audit]')
      }

      it { 
        is_expected.top contain_file_line('auditd_restart_enable').with()
      }
      # If you leave AuditD as-is, you'll get an error because the default is to not allow AuditD to restart. For the
# purposes of CIS hardening, you have to be able to specify options and restart the service. This changes the option
# when Puppet runs. It will only be activated once booted after the Puppet run.
file_line { 'auditd_restart_enable':
  ensure => 'present',
  path   => '/usr/lib/systemd/system/auditd.service',
  line   => 'RefuseManualStop=no',
  match  => '^RefuseManualStop\=',
}

      # Configure Data Retention - 4.1.2
      # Ensure audit log storage size is configured - Section 4.1.2.1
      it {
        is_expected.to contain_file_line('set_auditd_logfile_size').with(
          'ensure' => 'present',
          'path'   => '/etc/audit/auditd.conf',
          'line'   => 'max_log_file = 1024',
          'match'  => '^max_log_file\ \=',
        ).that_notifies('Exec[restart_auditd]')
      }

      # Ensure that Ensure audit logs are not automatically deleted - Section 4.1.2.2
      it {
        is_expected.to contain_file_line('set_max_logfile_action').with(
          'ensure' => 'present',
          'path'   => '/etc/audit/auditd.conf',
          'line'   => 'max_log_file_action = keep_logs',
          'match'  => '^max_log_file_action\ \=',
        )
      }

      # Ensure system is disabled when audit logs are full - Section 4.1.2.3
      it {
        is_expected.to contain_file_line('full_logfile_notify_action').with(
          'ensure' => 'present',
          'path'   => '/etc/audit/auditd.conf',
          'line'   => 'space_left_action = email',
          'match'  => '^space_left_action\ \=',
        ).that_notifies('Exec[restart_auditd]')
      }

      it {
        is_expected.to contain_file_line('set_action_mail_account').with(
          'ensure' => 'present',
          'path'   => '/etc/audit/auditd.conf',
          'line'   => 'action_mail_acct = root',
          'match'  => '^action_mail_acct\ \=',
        ).that_notifies('Exec[restart_auditd]')
      }

      it {
        is_expected.to contain_file_line('set_admin_space_left_action').with(
          'ensure' => 'present',
          'path'   => '/etc/audit/auditd.conf',
          'line'   => 'admin_space_left_action = SYSLOG',
          'match'  => '^admin_space_left_action\ \=',
        ).that_notifies('Exec[restart_auditd]')
      }

      # Ensure audit_backlog_limit is sufficient - Section 4.1.2.4 - PASS

      # Ensure defaults directory is present for grub settings - Section 4.1.3 prerequisites
      it {
        is_expected.to contain_file('/etc/default').with(
          'ensure' => 'directory',
          'owner'  => 'root',
          'group'  => 'root',
          'mode'   => '0755',
        )
      }

      it {
        is_expected.to contain_file('/etc/default/grub').with(
          'ensure'  => 'file',
          'owner'   => 'root',
          'group'   => 'root',
          'mode'    => '0644',
        ).that_requires('File[/etc/default]')
      }



      # Ensure events that modify date and time information are collected - Section 4.1.3
      it {
        is_expected.to contain_file_line('time_change_64bit_item1').with(
          'ensure' => 'present',
          'path'   => '/etc/audit/audit.rules',
          'line'   => '-a always,exit -F arch=b64 -S adjtimex -S settimeofday -k time-change',
        )
      }

      it {
        is_expected.to contain_file_line('time_change_64bit_item2').with(
          'ensure' => 'present',
          'path'   => '/etc/audit/audit.rules',
          'line'   => '-a always,exit -F arch=b64 -S clock_settime -k time-change',
        )
      }

      it {
        is_expected.to contain_file_line('time_change_64bit_item3').with(
          'ensure' => 'present',
          'path'   => '/etc/audit/audit.rules',
          'line'   => '-w /etc/localtime -p wa -k time-change',
        )
      }

      # Ensure events that modify user/group information are collected - Section 4.1.4
      it {
        is_expected.to contain_file_line('ownerchange_group').with(
          'ensure' => 'present',
          'path'   => '/etc/audit/audit.rules',
          'line'   => '-w /etc/group -p wa -k identity',
        )
      }

      it {
        is_expected.to contain_file_line('ownerchange_passwd').with(
          'ensure' => 'present',
          'path'   => '/etc/audit/audit.rules',
          'line'   => '-w /etc/passwd -p wa -k identity',
        )
      }

      it {
        is_expected.to contain_file_line('ownerchange_gshadow').with(
          'ensure' => 'present',
          'path'   => '/etc/audit/audit.rules',
          'line'   => '-w /etc/gshadow -p wa -k identity',
        )
      }

      it {
        is_expected.to contain_file_line('ownerchange_shadow').with(
          'ensure' => 'present',
          'path'   => '/etc/audit/audit.rules',
          'line'   => '-w /etc/shadow -p wa -k identity',
        )
      }

      it {
        is_expected.to contain_file_line('ownerchange_opasswd').with(
          'ensure' => 'present',
          'path'   => '/etc/audit/audit.rules',
          'line'   => '-w /etc/security/opasswd -p wa -k identity',
        )
      }

      # Ensure events that modify the system's network environment are collected - Section 4.1.5
      it {
        is_expected.to contain_file_line('network_namechanges').with(
          'ensure' => 'present',
          'path'   => '/etc/audit/audit.rules',
          'line'   => '-a always,exit -F arch=b64 -S sethostname -S setdomainname -k system-locale',
        )
      }

      it {
        is_expected.to contain_file_line('network_issue').with(
          'ensure' => 'present',
          'path'   => '/etc/audit/audit.rules',
          'line'   => '-w /etc/issue -p wa -k system-locale',
        )
      }

      it {
        is_expected.to contain_file_line('network_issuedotnet').with(
          'ensure' => 'present',
          'path'   => '/etc/audit/audit.rules',
          'line'   => '-w /etc/issue.net -p wa -k system-locale',
        )
      }

      it {
        is_expected.to contain_file_line('network_network').with(
          'ensure' => 'present',
          'path'   => '/etc/audit/audit.rules',
          'line'   => '-w /etc/sysconfig/network -p wa -k system-locale',
        )
      }

      it {
        is_expected.to contain_file_line('network_networkscripts').with(
          'ensure' => 'present',
          'path'   => '/etc/audit/audit.rules',
          'line'   => '-w /etc/sysconfig/network-scripts/ -p wa -k system-locale',
        )
      }

      # Ensure events that modify the system's Mandatory Access Controls are collected - Section 4.1.6
      it {
        is_expected.to contain_file_line('macpolicy_selinux').with(
          'ensure' => 'present',
          'path'   => '/etc/audit/audit.rules',
          'line'   => '-w /etc/selinux/ -p wa -k MAC-policy',
        )
      }

      it {
        is_expected.to contain_file_line('macpolicy_selinuxshare').with(
          'ensure' => 'present',
          'path'   => '/etc/audit/audit.rules',
          'line'   => '-w /usr/share/selinux/ -p wa -k MAC-policy',
        )
      }

      # Ensure that Ensure login and logout events are collected - Section 4.1.7
      it {
        is_expected.to contain_file_line('lastlogin').with(
          'ensure' => 'present',
          'path'   => '/etc/audit/audit.rules',
          'line'   => '-w /var/log/lastlog -p wa -k logins',
        )
      }

      it {
        is_expected.to contain_file_line('faillog').with(
          'ensure' => 'present',
          'path'   => '/etc/audit/audit.rules',
          'line'   => '-w /var/log/faillog -p wa -k logins',
        )
      }

      it {
        is_expected.to contain_file_line('faillock').with(
          'ensure' => 'present',
          'path'   => '/etc/audit/audit.rules',
          'line'   => '-w /var/run/faillock/ -p wa -k logins',
        )
      }

      # Ensure session initiation information is collected - Section 4.1.8
      it {
        is_expected.to contain_file_line('utmp_entry').with(
          'ensure' => 'present',
          'path'   => '/etc/audit/audit.rules',
          'line'   => '-w /var/run/utmp -p wa -k session',
        )
      }

      it {
        is_expected.to contain_file_line('wtmp_entry').with(
          'ensure' => 'present',
          'path'   => '/etc/audit/audit.rules',
          'line'   => '-w /var/run/wtmp -p wa -k logins',
        )
      }

      it {
        is_expected.to contain_file_line('btmp_entry').with(
          'ensure' => 'present',
          'path'   => '/etc/audit/audit.rules',
          'line'   => '-w /var/run/btmp -p wa -k logins',
        )
      }

      # Ensure discretionary access control permission modification events are collected - Section 4.1.9
      it {
        is_expected.to contain_file_line('chmod_cmds').with(
          'ensure' => 'present',
          'path'   => '/etc/audit/audit.rules',
          'line'   => '-a always,exit -F arch=b64 -S chmod -S fchmod -S fchmodat -F auid>=1000 -F auid!=4294967295 -k perm_mod',
        )
      }

      it {
        is_expected.to contain_file_line('chown_cmds').with(
          'ensure' => 'present',
          'path'   => '/etc/audit/audit.rules',
          'line'   => '-a always,exit -F arch=b64 -S chown -S fchown -S fchownat -S lchown -F auid>=1000 -F auid!=4294967295 -k perm_mod',
        )
      }

      it {
        is_expected.to contain_file_line('xattr_cmds').with(
          'ensure' => 'present',
          'path'   => '/etc/audit/audit.rules',
          'line'   => '-a always,exit -F arch=b64 -S setxattr -S lsetxattr -S fsetxattr -S removexattr -S lremovexattr -S fremovexattr -F auid>=1000 -F auid!=4294967295 -k perm_mod',
        )
      }

      # Ensure unsuccessful unauthorized file access attempts are collected - Section 4.1.10
      it {
        is_expected.to contain_file_line('file_truncate').with(
          'ensure' => 'present',
          'path'   => '/etc/audit/audit.rules',
          'line'   => '-a always,exit -F arch=b64 -S creat -S open -S openat -S truncate -S ftruncate -F exit=-EACCES -F auid>=1000 -F auid!=4294967295 -k access',
        )
      }

      # Ensure use of privileged commands is collected - Section 4.1.11 **unused**

      # Ensure succesful filesystem mounts are collected - Section 4.1.12
      it {
        is_expected.to contain_file_line('mount_cmds').with(
          'ensure' => 'present',
          'path'   => '/etc/audit/audit.rules',
          'line'   => '-a always,exit -F arch=b64 -S mount -F auid>=1000 -F auid!=4294967295 -k mounts',
        )
      }

      # Ensure that Ensure file deletion events by users are captured - Section 4.1.13
      it {
        is_expected.to contain_file_line('file_deletions').with(
          'ensure' => 'present',
          'path'   => '/etc/audit/audit.rules',
          'line'   => '-a always,exit -F arch=b64 -S unlink -S unlinkat -S rename -S renameat -F auid>=1000 -F auid!=4294967295 -k delete',
        )
      }

      # Ensure that Ensure changes to system administration scope (sudoers) is collected - Section 4.1.14
      it {
        is_expected.to contain_file_line('sudoers_file').with(
          'ensure' => 'present',
          'path'   => '/etc/audit/audit.rules',
          'line'   => '-w /etc/sudoers -p wa -k scope',
        )
      }

      it {
        is_expected.to contain_file_line('sudoers_dir').with(
          'ensure' => 'present',
          'path'   => '/etc/audit/audit.rules',
          'line'   => '-w /etc/sudoers.d/ -p wa -k scope',
        )
      }

      # Ensure that Ensure system administrator actions (sudolog) are collected - Section 4.1.15
      it {
        is_expected.to contain_file_line('sudolog').with(
          'ensure' => 'present',
          'path'   => '/etc/audit/audit.rules',
          'line'   => '-w /var/log/sudo.log -p wa -k actions',
        )
      }

      # Ensure that Ensure Kernel module loading and unloading are collected - Section 4.1.16
      it {
        is_expected.to contain_file_line('check_insmod').with(
          'ensure' => 'present',
          'path'   => '/etc/audit/audit.rules',
          'line'   => '-w /sbin/insmod -p x -k modules',
        )
      }

      it {
        is_expected.to contain_file_line('check_rmmod').with(
          'ensure' => 'present',
          'path'   => '/etc/audit/audit.rules',
          'line'   => '-w /sbin/rmmod -p x -k modules',
        )
      }

      it {
        is_expected.to contain_file_line('check_modprobe').with(
          'ensure' => 'present',
          'path'   => '/etc/audit/audit.rules',
          'line'   => '-w /sbin/modprobe -p x -k modules',
        )
      }

      it {
        is_expected.to contain_file_line('check_modulestate').with(
          'ensure' => 'present',
          'path'   => '/etc/audit/audit.rules',
          'line'   => '-a always,exit -F arch=b64 -S init_module -S delete_module -k modules',
        )
      }

      # Ensure the audit configuration is immutable - Section 4.1.17
      it {
        is_expected.to contain_file_line('make_auditd_immutable').with(
          'ensure'             => 'present',
          'path'               => '/etc/audit/audit.rules',
          'line'               => '-e 2',
          'match'              => '^-e\ ',
          'append_on_no_match' => true,
        )
      }

      # Ensure manifest compiles with all dependencies
      it {
        is_expected.to compile.with_all_deps
      }
    end
  end
end
