require 'spec_helper_acceptance'

  # Enable Cron Daemon - Section 5.1.1
  describe service('crond') do
    it { is_expected.to be_running }
  end

  # Ensure permissions on /etc/crontab are configured - Section 5.1.2
  describe file('/etc/crontab') do
    it { is_expected.to be_file }
    it { is_expected.to be_owned_by 'root' }
    it { is_expected.to be_grouped_into 'root' }
    it { is_expected.to be_mode 644
  end

  # Ensure permissions on /etc/cron.hourly are configured - Section 5.1.3
  describe file('/etc/cron.hourly') do
    it { is_expected.to be_directory }
    it { is_expected.to be_owned_by 'root' }
    it { is_expected.to be_grouped_into 'root' }
    it { is_expected.to be_mode 700 }
  end

  # Ensure permissions on /etc/cron.daily are configured - Section 5.1.4
  describe file('/etc/cron.daily') do
    it { is_expected.to be_directory }
    it { is_expected.to be_owned_by 'root' }
      is_expected.to be_grouped_into 'root'
      is_expected.to be_mode 700
    end
  end

  # Ensure permissions on /etc/cron.weekly are configured - Section 5.1.5
  describe file('/etc/cron.weekly') do
    it do
      is_expected.to be_directory
      is_expected.to be_owned_by 'root'
      is_expected.to be_grouped_into 'root'
      is_expected.to be_mode 700
    end
  end

  # Ensure permissions on /etc/cron.monthly are configured - Section 5.1.6
  describe file('/etc/cron.monthly') do
      it do
        is_expected.to be_directory
        is_expected.to be_owned_by 'root'
        is_expected.to be_grouped_into 'root'
        is_expected.to be_mode 700
      end
    end

  # Ensure permissions on /etc/cron.d are configured - Section 5.1.7
  describe file('/etc/cron.monthly') do
    it do
      is_expected.to be_directory
      is_expected.to be_owned_by 'root'
      is_expected.to be_grouped_into 'root'
      is_expected.to be_mode 700
    end
  end

  # Ensure at/cron is restricted to authorized users - Section 5.1.8
  describe file('/etc/at.deny') do
    it do
      is_expected.not_to be_file
    end
  end

  describe file('/etc/cron.deny') do
    it do
      is_expected.not_to be_file
    end
  end

  describe file('/etc/cron.allow') do
    it do
      is_expected.to be_file
      is_expected.to be_owned_by 'root'
      is_expected.to be_grouped_into 'root'
      is_expected.to be_mode 600
    end
  end

  describe file('/etc/at.allow') do
    it do
      is_expected.to be_file
      is_expected.to be_owned_by 'root'
      is_expected.to be_grouped_into 'root'
      is_expected.to be_mode 600
    end
  end
