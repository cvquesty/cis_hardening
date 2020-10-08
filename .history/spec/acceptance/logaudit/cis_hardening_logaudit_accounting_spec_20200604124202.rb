require 'spec_helper_acceptance'
  
  # Ensure that audit is installed
  describe package('audit') do
      it { should be_installed }
  end

  # Make sure rules file is present
  # Ensure events that modify date and time information are collected - Section 4.1.4
  # Ensure events that modify user/group information are collected - Section 4.1.5
  describe file('/etc/audit/audit.rules') do
      it { is_expected.to be_file }
      it { is_expected.to be_owned_by 'root' }
      it { is_expected.to be_grouped_into 'root' }
      it { is_expected.to be_mode 640 }
      its(:content) { should match /-a always\,exit -F arch=b64 -S adjtimex -S settimeofday -k time-change/ }
      its(:content) { should match /-a always\,exit -F arch=b64 -S clock_settime -k time-change/ }
      its(:content) { should match /-w \/etc\/localtime -p wa -k time-change/ }
      its(:content) { should match /-w \/etc\/group -p wa -k identity/ }
      its(:content) { should match /-w \/etc\/passwd -p wa -k identity/ }
      its(:content) { should match /-w \/etc\/gshadow -p wa -k identity/ }
      its(:content) { should match /-w \/etc\/shadow -p wa -k identity/ }
      its(:content) { should match /-w \/etc\/opasswd -p wa -k identity/ }
  end

  # Check AuditD Configuration Options
  # Ensure audit log storage size is configured - Section 4.1.1.1
  # 4.1.1.2 Not Used
  # Ensure audit logs are not automatically deleted - Section 4.1.1.3
  describe file('/etc/audit/audit.conf') do
    it do
      is_expected.to be_file
      is_expected.to contain 'max_log_file = 1024'
      is_expected.to contain 'space_left_action = email'
      is_expected.to contain 'action_mail_acct = root'
      is_expected.to contain 'admin_space_left_action = SYSLOG'
      is_expected.to contain 'max_log_file_action = keep_logs'
    end
  end
  
  # Ensure auditd service is enabled - Section 4.1.2
  describe service('auditd') do
    it do
      should be_enabled
      should be_running
    end
  end

  # Ensure defaults directory is present for grub settings - Section 4.1.3 prerequisites
  # Ensure auditing for processes that start prior to auditd is enabled - Section 4.1.3

  describe file('/etc/default') do
    it do
      is_expected.to be_directory
      is_expected.to be_owned_by 'root'
      is_expected.to be_grouped_into 'root'
      is_expected.to be_mode 755
    end
  end

  describe file('/etc/default/grub') do
    it do
      is_expected.to be_file
      is_expected.to be_owned_by 'root'
      is_expected.to be_grouped_into 'root'
      is_expected.to be_mode 644
      is_expected.to contain 'GRUB_CMDLINE_LINUX="audit=1"'
    end
  end


    
end