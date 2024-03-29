require 'spec_helper_acceptance'

describe 'Accounts Settings' do
  describe 'cis_hardening_auth_accounts class' do
    context 'default parameters' do
      it 'behaves idempotently' do
        idempotent_apply(pp)
      end
    end
  end

  # Ensure Password expiration is 365 days or less - Section 5.4.1.1
  # Ensure minimum days between password changes is 7 or more - Section 5.4.1.2
  # Ensure Pasword Expiration warning days is 7 or more - Section 5.4.1.3
  describe file('/etc/login.defs') do
    it { is_expected.to be_file }
    it {
      its(:content) { is_expected.to match %r{/PASS_MAX_DAYS 365/} }
    }
    it {
      its(:content) { is_expected.to match %r{/PASS_MIN_DAYS 7/} }
    }
    it {
      its(:content) { is_expected.to match %r{/PASS_WARN_AGE 7/} }
    }
  end

  # Ensure default group for the root account is GID 0 - Section 5.4.3
  describe user('root') do
    it { is_expected.to exist }
    it { is_expected.to belong_to_group 'root' }
  end

  # Ensure default user umask is 027 or more restrictive - Section 5.4.4
  # Ensure default user shell tieout is 900 seconds or less - Section 5.4.5
  describe file('/etc/profile.d/cisumaskprofile.sh') do
    it { is_expected.to be_file }
    it {
      its(:content) { is_expected.to match %r{/umask 027/} }
    }
    it {
      its(:content) { is_expected.to match %r{/TMOUT=600/} }
    }
  end

  describe file('/etc/profile.d/cisumaskbashrc.sh') do
    it { is_expected.to be_file }
    it {
      its(:content) { is_expected.to match %r{/umask 027/} }
    }
    it {
      its(:content) { is_expected.to match %r{/TMOUT=600/} }
    }
  end
end
