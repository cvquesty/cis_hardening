require 'spec_helper_acceptance'

describe 'Logging Configuration' do
  describe 'cis_hardening_logaudit_logging class' do
    context 'default parameters' do
      it 'behaves idempotently' do
        idempotent_apply(pp)
      end
    end
  end

  # Ensure rsyslog service is enabled - Section 4.2.1.1
  describe service('rsyslog') do
    it { is_expected.to be_running }
    it { is_expected.to be_enabled }
  end

  # Ensure logging is configured - Section 4.2.1.2
  describe file('/etc/rsyslog.conf') do
    it { is_expected.to be_file }
    its(:content) { is_expected.to match %r{/$FileCreateMode 0640/} }
  end

  # Ensure rsyslog (or syslog-ng) is installed - Section 4.2.3
  describe package('rsyslog') do
    it { is_expected.to be_installed }
  end
end
