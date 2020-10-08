# @summary A manifest to configure system accounting according to
# CIS hardening Guidelines
#
# Configure System Accounting - Section 4.1
#
# @example
#   include cis_hardening::logaudit::accounting
class cis_hardening::logaudit::accounting {

  # Ensure that audit is installed
  package { 'audit':
    ensure => 'present',
  }

  # Exec to notify from auditd rules changes - Section 4.1.1
  exec { 'restart_auditd':
    path    => '/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin',
    command => '/bin/systemctl restart auditd',
    require => Package['audit'],
  }

  # AuditD is using an include directory now, but I have opted for audit.rules for the time being.
  # Expect refactoring here
  file { '/etc/audit/audit.rules':
    ensure  => 'present',
    owner   => 'root',
    group   => 'root',
    mode    => '0640',
    require => Package['audit'],
  }

  # Ensure audit log storage size is configured - Section 4.1.1.1
  file_line { 'set_auditd_logfile_size':
    ensure => 'present',
    path   => '/etc/audit/auditd.conf',
    line   => 'max_log_file = 1024',
    match  => '^max_log_file\ \=',
    notify => Exec['restart_auditd'],
  }

  # Ensure system is disabled when audit logs are full - Section 4.1.1.2
  #
  # Acceptable risk. The servers cannot be shut down in production due to a 
  # lack of logging. Instead, the below will alert SysLog that logging is not
  # occurring, and an alert should be set for the related condition, that is, 
  # that logs are no longer being produced. One would also argue that disk space
  # alerts would also notify operational personnel of the condition
  
  file_line { 'full_logfile_notify_action':
    ensure => 'present',
    path   => '/etc/audit/auditd.conf',
    line   => 'space_left_action = email',
    match  => '^space_left_action\ \=',
    notify => Exec['restart_auditd'],
  }
  
  file_line { 'set_action_mail_account':
    ensure => 'present',
    path   => '/etc/audit/auditd.conf',
    line   => 'action_mail_acct = root',
    match  => '^action_mail_acct\ \=',
    notify => Exec['restart_auditd'],
  }

  file_line { 'set_admin_space_left_action':
    ensure => 'present',
    path   => '/etc/audit/auditd.conf',
    line   => 'admin_space_left_action = SYSLOG',
    match  => '^admin_space_left_action\ \=',
    notify => Exec['restart_auditd'],
  }

  # Ensure audit logs are not automatically deleted - Section 4.1.1.3
  file_line { 'set_max_logfile_action':
    ensure => 'present',
    path   => '/etc/audit/auditd.conf',
    line   => 'max_log_file_action = keep_logs',
    match  => '^max_log_file_action\ \=',
    notify => Exec['restart_auditd'],
  }

  # Ensure auditd service is enabled - Section 4.1.2
  service { 'auditd':
    ensure     => 'running',
    enable     => true,
    hasstatus  => true,
    hasrestart => true,
    require    => File['/etc/audit/audit.rules'],
  }

  # Ensure defaults directory is present for grub settings - Section 4.1.3 prerequisites
  file { '/etc/default':
    ensure => 'directory',
    owner  => 'root',
    group  => 'root',
    mode   => '0755',
  }

  file { '/etc/default/grub':
    ensure  => 'file',
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    require => File['/etc/default'],
  }

  # Ensure auditing for processes that start prior to auditd is enabled - Section 4.1.3
  file_line { 'pre_auditd_settings':
    ensure  => 'present',
    path    => '/etc/default/grub',
    line    => 'GRUB_CMDLINE_LINUX="audit=1"',
    match   => '^GRUB_CMDLINE_LINUX\=',
    require => File['/etc/default/grub'],
  }

  # Ensure events that modify date and time information are collected - Section 4.1.4
  file_line { 'time_change_64bit_item1':
    ensure => 'present',
    path   => '/etc/audit/audit.rules',
    line   => '-a always,exit -F arch=b64 -S adjtimex -S settimeofday -k time-change',
  }

  file_line { 'time_change_64bit_item2':
    ensure => 'present',
    path   => '/etc/audit/audit.rules',
    line   => '-a always,exit -F arch=b64 -S clock_settime -k time-change',
  }

  file_line { 'time_change_64bit_item3':
    ensure => 'present',
    path   => '/etc/audit/audit.rules',
    line   => '-w /etc/localtime -p wa -k time-change',
  }

  # Ensure events that modify user/group information are collected - Section 4.1.5
  file_line { 'ownerchange_group':
    ensure => 'present',
    path   => '/etc/audit/audit.rules',
    line   => '-w /etc/group -p wa -k identity',
  }

  file_line { 'ownerchange_passwd':
    ensure => 'present',
    path   => '/etc/audit/audit.rules',
    line   => '-w /etc/passwd -p wa -k identity',
  }

  file_line { 'ownerchange_gshadow':
    ensure => 'present',
    path   => '/etc/audit/audit.rules',
    line   => '-w /etc/gshadow -p wa -k identity',
  }

  file_line { 'ownerchange_shadow':
    ensure => 'present',
    path   => '/etc/audit/audit.rules',
    line   => '-w /etc/shadow -p wa -k identity',
  }

  file_line { 'ownerchange_opasswd':
    ensure => 'present',
    path   => '/etc/audit/audit.rules',
    line   => '-w /etc/security/opasswd -p wa -k identity',
  }

  # NOTE: Above audit.rules settings may require a reboot to become effective especially in regards
  # to those rules to be activated prior to Grub's loading

  # Ensure events that modify the system's network environment are collected - Section 4.1.6
  file_line { 'network_namechanges':
    ensure => 'present',
    path   => '/etc/audit/audit.rules',
    line   => '-a always,exit -F arch=b64 -S sethostname -S setdomainname -k system-locale',
  }

  file_line { 'network_issue':
    ensure => 'present',
    path   => '/etc/audit/audit.rules',
    line   => '-w /etc/issue -p wa -k system-locale',
  }

  file_line { 'network_issuedotnet':
    ensure => 'present',
    path   => '/etc/audit/audit.rules',
    line   => '-w /etc/issue.net -p wa -k system-locale',
  }

  file_line { 'network_network':
    ensure => 'present',
    path   => '/etc/audit/audit.rules',
    line   => '-w /etc/sysconfig/network -p wa -k system-locale',
  }

  file_line { 'network_networkscripts':
    ensure => 'present',
    path   => '/etc/audit/audit.rules',
    line   => '-w /etc/sysconfig/network-scripts/ -p wa -k system-locale',
  }

  # Ensure events that modify the system's Mandatory Access Controls are collected - Section 4.1.7
  file_line { 'macpolicy_selinux':
    ensure => 'present',
    path   => '/etc/audit/audit.rules',
    line   => '-w /etc/selinux/ -p wa -k MAC-policy',
  }

  file_line { 'macpolicy_selinuxshare':
    ensure => 'present',
    path   => '/etc/audit/audit.rules',
    line   => '-w /usr/share/selinux/ -p wa -k MAC-policy',
  }

  # Ensure login and logout events are collected - Section 4.1.8
  file_line { 'lastlogin':
    ensure => 'present',
    path   => '/etc/audit/audit.rules',
    line   => '-w /var/log/lastlog -p wa -k logins',
  }

  file_line { 'faillock':
    ensure => 'present',
    path   => '/etc/audit/audit.rules',
    line   => '-w /var/run/faillock/ -p wa -k logins',
  }

  # Ensure session initiation information is collected - Section 4.1.9
  file_line { 'utmp_entry':
    ensure => 'present',
    path   => '/etc/audit/audit.rules',
    line   => '-w /var/run/utmp -p wa -k session',
  }

  file_line { 'wtmp_entry':
    ensure => 'present',
    path   => '/etc/audit/audit.rules',
    line   => '-w /var/run/wtmp -p wa -k logins',
  }

  file_line { 'btmp_entry':
    ensure => 'present',
    path   => '/etc/audit/audit.rules',
    line   => '-w /var/run/btmp -p wa -k logins',
  }

  # Ensure discretionary access control permission modification events are collected - Section 4.1.10
  file_line { 'chmod_cmds':
    ensure => 'present',
    path   => '/etc/audit/audit.rules',
    line   => '-a always,exit -F arch=b64 -S chmod -S fchmod -S fchmodat -F auid>=1000 -F auid!=4294967295 -k perm_mod',
  }

  file_line { 'chown_cmds':
    ensure => 'present',
    path   => '/etc/audit/audit.rules',
    line   => '-a always,exit -F arch=b64 -S chown -S fchown -S fchownat -S lchown -F auid>=1000 -F auid!=4294967295 -k perm_mod',
  }

  file_line { 'xattr_cmds':
    ensure => 'present',
    path   => '/etc/audit/audit.rules',
    line   => '-a always,exit -F arch=b64 -S setxattr -S lsetxattr -S fsetxattr -S removexattr -S lremovexattr -S fremovexattr -F auid>=1000 -F auid!=4294967295 -k perm_mod',
  }

  # Ensure unsuccessful unauthorized file access attempts are collected - Section 4.1.11
  file_line { 'file_truncate':
    ensure => 'present',
    path   => '/etc/audit/audit.rules',
    line   => '-a always,exit -F arch=b64 -S creat -S open -S openat -S truncate -S ftruncate -F exit=-EACCES -F auid>=1000 -F auid!=4294967295 -k access',
  }

  # Ensure use of privileged commands is collected - Section 4.1.12
  # Given that elevated privilege commands can only be found via ad-hoc queries
  # of the filesystem/logfiles, it is not possible to generate the needed audit rules
  # without orchestration and/or custom facts. Will revisit

  # Ensure succesful filesystem mounts are collected - Section 4.1.13
  file_line { 'mount_cmds':
    ensure => 'present',
    path   => '/etc/audit/audit.rules',
    line   => '-a always,exit -F arch=b64 -S mount -F auid>=1000 -F auid!=4294967295 -k mounts',
  }

  # Ensure file deletion events by users are captured - Section 4.1.14
  file_line { 'file_deletions':
    ensure => 'present',
    path   => '/etc/audit/audit.rules',
    line   => '-a always,exit -F arch=b64 -S unlink -S unlinkat -S rename -S renameat -F auid>=1000 -F auid!=4294967295 -k delete',
  }

  # Ensure changes to system administration scope (sudoers) is collected - Section 4.1.15
  file_line { 'sudoers_file':
    ensure => 'present',
    path   => '/etc/audit/audit.rules',
    line   => '-w /etc/sudoers -p wa -k scope',
  }

  file_line { 'sudoers_dir':
    ensure => 'present',
    path   => '/etc/audit/audit.rules',
    line   => '-w /etc/sudoers.d/ -p wa -k scope',
  }

  # Ensure system administrator actions (sudolog) are collected - Section 4.1.16
  file_line { 'sudolog':
    ensure => 'present',
    path   => '/etc/audit/audit.rules',
    line   => '-w /var/log/sudo.log -p wa -k actions',
  }

  # Ensure Kernel module loading and unloading are collected - Section 4.1.17
  file_line { 'check_insmod':
    ensure => 'present',
    path   => '/etc/audit/audit.rules',
    line   => '-w /sbin/insmod -p x -k modules',
  }

  file_line { 'check_rmmod':
    ensure => 'present',
    path   => '/etc/audit/audit.rules',
    line   => '-w /sbin/rmmod -p x -k modules',
  }

  file_line { 'check_modprobe':
    ensure => 'present',
    path   => '/etc/audit/audit.rules',
    line   => '-w /sbin/modprobe -p x -k modules',
  }

  file_line { 'check_modulestate':
    ensure => 'present',
    path   => '/etc/audit/audit.rules',
    line   => '-a always,exit -F arch=b64 -S init_module -S delete_module -k modules',
  }

  # Ensure the audit configuration is immutable - Section 4.1.18
  file_line { 'make_auditd_immutable':
    ensure             => 'present',
    path               => '/etc/audit/audit.rules',
    line               => '-e 2',
    match              => '^-e\ ',
    append_on_no_match => true,
  }
}
