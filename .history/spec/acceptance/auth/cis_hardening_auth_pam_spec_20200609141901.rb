require 'spec_helper_acceptance'

describe 'cis_hardening_auth_ class' do
  context 'default parameters' do
    it 'behaves idempotently' do
      idempotent_apply(pp)
    end
  end
end

# Ensure Password creation requirements are configured - Section 5.3.1
describe file('/etc/security/pwquality.conf') do
  it { is_expected.to be_file }
  it { is_expected.to be_owned_by 'root' }
  it { is_expected.to be_grouped_into 'root' }
  it { is_expected.to be_mode 644 }
  it { is_expected.to contain 'minlen = 14' }
end

# Ensure lockout delay for failed password attempts is configured - Section 5.3.2
# Ensure Password Reuse is Limited - Section 5.3.3
# Ensure Password Hashing Algorithm is SHA-512 - Section 5.3.4
describe file('/etc/pam.d/system-auth-ac') do
  it { is_expected.to be_file }
  it { is_expected.to contain 'pam_faildelay.so delay=2000000' }
  it { is_expected.to contain 'remember=5' }
  it { is_expected.to contain 'sha512' }
end

describe file('/etc/pam.d/password-auth-ac') do
  it { is_expected.to be_file }
  it { is_expected.to contain 'pam_faildelay.so delay=2000000' }
  it { is_expected.to contain 'remember=5' }
  it { is_expected.to contain 'sha512' }
end
