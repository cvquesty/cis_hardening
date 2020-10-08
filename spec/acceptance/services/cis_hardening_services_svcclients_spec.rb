require 'spec_helper_acceptance'

describe 'Services to be disabled' do
  # Ensure NIS CLient is not installed - Section 2.3.1
  describe package('ypbind') do
    it { is_expected.not_to be_installed }
  end

  # Ensure rsh Client is not installed - Section 2.3.2
  describe package('rsh') do
    it { is_expected.not_to be_installed }
  end

  # Ensure talk client is not installed - Section 2.3.3
  describe package('talk') do
    it { is_expected.not_to be_installed }
  end

  # Ensure telnet client is not installed - Section 2.3.4
  describe package('telnet') do
    it { is_expected.not_to be_installed }
  end

  # Ensure LDAP client is not installed - Section 2.3.5
  describe package('openldap-clients') do
    it { is_expected.not_to be_installed }
  end
end
