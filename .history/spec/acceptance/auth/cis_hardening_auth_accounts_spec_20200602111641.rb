require 'spec_helper_acceptance'

  # Ensure Password expiration is 365 days or less - Section 5.4.1.1
  # Ensure minimum days between password changes is 7 or more - Section 5.4.1.2
  # Ensure Pasword Expiration warning days is 7 or more - Section 5.4.1.3
  describe file('/etc/login.defs') do
    it do
      is_expected.to be_file
      is_expected.to contain 'PASS_MAX_DAYS 365'
      is_expected.to contain 'PASS_MIN_DAYS 7'
      is_expected.to contain 'PASS_WARN_AGE 7'
    end
  end

  # Ensure default group for the root account is GID 0 - Section 5.4.3
  describe user('root') do
    it do
      is_expected.to exist
      is_expected.to belong_to_group 'root'
    end
  end

  # Ensure default user umask is 027 or more restrictive - Section 5.4.4
  # Ensure default user shell tieout is 900 seconds or less - Section 5.4.5
  describe file('/etc/profile') do
    it do
      is_expected.to be_file
      is_expected.to contain 'umask 027'
      is_expected.to contain 'TMOUT=600'
    end
  end

  describe file('/etc/bashrc') do
    it do
      is_expected.to be_file
      is_expected.to contain 'umask 027'
      is_expected.to contain 'TMOUT=600'
    end
  end


