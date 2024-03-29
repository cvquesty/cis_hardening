require 'spec_helper_acceptance'

describe 'Logaudit Accounting Configuration' do
  describe 'cis_hardening_logaudit_accounting class' do
    context 'default parameters' do
      it 'behaves idempotently' do
        idempotent_apply(pp)
      end
    end
  end

  # Ensure that audit is installed
  describe package('audit') do
    it { is_expected.to be_installed }
  end

  # Make sure rules file is present
  # Ensure events that modify date and time information are collected - Section 4.1.4
  # Ensure events that modify user/group information are collected - Section 4.1.5
  # Ensure events that modify the system's network environment are collected - Section 4.1.6
  # Ensure events that modify the system's Mandatory Access Controls are collected - Section 4.1.7
  # Ensure login and logout events are collected - Section 4.1.8
  # Ensure session initiation information is collected - Section 4.1.9
  # Ensure discretionary access control permission modification events are collected - Section 4.1.10
  # Ensure unsuccessful unauthorized file access attempts are collected - Section 4.1.11
  # Ensure succesful filesystem mounts are collected - Section 4.1.13
  # Ensure file deletion events by users are captured - Section 4.1.14
  # Ensure changes to system administration scope (sudoers) is collected - Section 4.1.15
  # Ensure system administrator actions (sudolog) are collected - Section 4.1.16
  # Ensure Kernel module loading and unloading are collected - Section 4.1.17
  # Ensure the audit configuration is immutable - Section 4.1.18
  describe file('/etc/audit/audit.rules') do
    it { is_expected.to be_file }
    it { is_expected.to be_owned_by 'root' }
    it { is_expected.to be_grouped_into 'root' }
    it { is_expected.to be_mode 0o0640 }
    it {
      its(:content) { is_expected.to match %r{/-a always,exit -F arch=b64 -S adjtimex -S settimeofday -k time-change/} }
    }
    it {
      its(:content) { is_expected.to match %r{/-a always\,exit -F arch=b64 -S clock_settime -k time-change/} }
    }
    it {
      its(:content) { is_expected.to match %r{/-w \/etc\/localtime -p wa -k time-change/} }
    }
    it {
      its(:content) { is_expected.to match %r{/-w \/etc\/group -p wa -k identity/} }
    }
    it {
      its(:content) { is_expected.to match %r{/-w \/etc\/passwd -p wa -k identity/} }
    }
    it {
      its(:content) { is_expected.to match %r{/-w \/etc\/gshadow -p wa -k identity/} }
    }
    it {
      its(:content) { is_expected.to match %r{/-w \/etc\/shadow -p wa -k identity/} }
    }
    it {
      its(:content) { is_expected.to match %r{/-w \/etc\/security\/opasswd -p wa -k identity/} }
    }
    it {
      its(:content) { is_expected.to match %r{/-a always,exit -F arch=b64 -S sethostname -S setdomainname -k system-locale/} }
    }
    it {
      its(:content) { is_expected.to match %r{/-w \/etc\/issue -p wa -k system-locale/} }
    }
    it {
      its(:content) { is_expected.to match %r{/-w \/etc\/issue\.net -p wa -k system-locale/} }
    }
    it {
      its(:content) { is_expected.to match %r{/-w \/etc\/sysconfig\/network -p wa -k system-locale/} }
    }
    it {
      its(:content) { is_expected.to match %r{/-w \/etc\/sysconfig\/network-scripts\/ -p wa -k system-locale/} }
    }
    it {
      its(:content) { is_expected.to match %r{/-w \/etc\/selinux\/ -p wa -k MAC-policy/} }
    }
    it {
      its(:content) { is_expected.to match %r{/-w \/usr\/share\/selinux\/ -p wa -k MAC-policy/} }
    }
    it {
      its(:content) { is_expected.to match %r{/-w \/var\/log\/lastlog -p wa -k logins/} }
    }
    it {
      its(:content) { is_expected.to match %r{/-w \/var\/run\/faillock\/ -p wa -k logins/} }
    }
    it {
      its(:content) { is_expected.to match %r{/-w \/var\/run\/utmp -p wa -k session/} }
    }
    it {
      its(:content) { is_expected.to match %r{/-w \/var\/run\/wtmp -p wa -k logins/} }
    }
    it {
      its(:content) { is_expected.to match %r{/-w \/var\/run\/btmp -p wa -k logins/} }
    }
    it {
      its(:content) { is_expected.to match %r{/-a always,exit -F arch=b64 -S chmod -S fchmod -S fchmodat -F auid>=1000 -F auid!=4294967295 -k perm_mod/} }
    }
    it {
      its(:content) { is_expected.to match %r{/-a always,exit -F arch=b64 -S chown -S fchown -S fchownat -S lchown -F auid>=1000 -F auid!=4294967295 -k perm_mod/} }
    }
    it {
      its(:content) { is_expected.to match %r{/-a always,exit -F arch=b64 -S setxattr -S lsetxattr -S fsetxattr -S removexattr -S lremovexattr -S fremovexattr -F auid>=1000 -F auid!=4294967295 -k perm_mod/} }
    }
    it {
      its(:content) { is_expected.to match %r{/-a always,exit -F arch=b64 -S creat -S open -S openat -S truncate -S ftruncate -F exit=-EACCES -F auid>=1000 -F auid!=4294967295 -k access/} }
    }
    it {
      its(:content) { is_expected.to match %r{/-a always,exit -F arch=b64 -S mount -F auid>=1000 -F auid!=4294967295 -k mounts/} }
    }
    it {
      its(:content) { is_expected.to match %r{/-a always,exit -F arch=b64 -S unlink -S unlinkat -S rename -S renameat -F auid>=1000 -F auid!=4294967295 -k delete/} }
    }
    it {
      its(:content) { is_expected.to match %r{/-w \/etc\/sudoers -p wa -k scope/} }
    }
    it {
      its(:content) { is_expected.to match %r{/-w \/etc\/sudoers\.d\/ -p wa -k scope/} }
    }
    it {
      its(:content) { is_expected.to match %r{/-w \/var\/log\/sudo\.log -p wa -k actions/} }
    }
    it {
      its(:content) { is_expected.to match %r{/-w \/sbin\/insmod -p x -k modules/} }
    }
    it {
      its(:content) { is_expected.to match %r{/-w \/sbin\/rmmod -p x -k modules/} }
    }
    it {
      its(:content) { is_expected.to match %r{/-w \/sbin\/modprobe -p x -k modules/} }
    }
    it {
      its(:content) { is_expected.to match %r{/-a always,exit -F arch=b64 -S init_module -S delete_module -k modules/} }
    }
    it {
      its(:content) { is_expected.to match %r{/-e 2/} }
    }
  end

  # Check AuditD Configuration Options
  # Ensure audit log storage size is configured - Section 4.1.1.1
  # 4.1.1.2 Not Used
  # Ensure audit logs are not automatically deleted - Section 4.1.1.3
  describe file('/etc/audit/auditd.conf') do
    it { is_expected.to be_file }
    it {
      its(:content) { is_expected.to match %r{/max_log_file = 1024/} }
    }
    it {
      its(:content) { is_expected.to match %r{/space_left_action\ \=\ email/} }
    }
    it {
      its(:content) { is_expected.to match %r{/action_mail_acct = root/} }
    }
    it {
      its(:content) { is_expected.to match %r{/admin_space_left_action = SYSLOG/} }
    }
    it {
      its(:content) { is_expected.to match %r{/max_log_file_action = keep_logs/} }
    }
  end

  # Ensure auditd service is enabled - Section 4.1.2
  describe service('auditd') do
    it {
      it { is_expected.to be_enabled }
    }
    it {
      it { is_expected.to be_running }
    }
  end

  # Ensure defaults directory is present for grub settings - Section 4.1.3 prerequisites
  # Ensure auditing for processes that start prior to auditd is enabled - Section 4.1.3

  describe file('/etc/default') do
    it { is_expected.to be_directory }
    it { is_expected.to be_owned_by 'root' }
    it { is_expected.to be_grouped_into 'root' }
    it { is_expected.to be_mode 0o0755 }
  end

  describe file('/etc/default/grub') do
    it { is_expected.to be_file }
    it { is_expected.to be_owned_by 'root' }
    it { is_expected.to be_grouped_into 'root' }
    it { is_expected.to be_mode 0o0644 }
    its(:content) { is_expected.to match %r{/GRUB_CMDLINE_LINUX="audit=1"/} }
  end
end
