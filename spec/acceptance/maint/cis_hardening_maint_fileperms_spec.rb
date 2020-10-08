require 'spec_helper_acceptance'

describe 'File Permisions tests' do
  describe 'cis_hardening_maint_fileperms class' do
    context 'default parameters' do
      it 'behaves idempotently' do
        idempotent_apply(pp)
      end
    end
  end

  # Ensure permissions on /etc/passwd are configured - Section 6.1.2
  describe file('/etc/passwd') do
    it { is_expected.to be_file }
    it { is_expected.to be_owned_by 'root' }
    it { is_expected.to be_grouped_into 'root' }
    it { is_expected.to be_mode 0o0644 }
  end

  # Ensure permissions on /etc/shadow are configured - Section 6.1.3
  describe file('/etc/shadow') do
    it { is_expected.to be_file }
    it { is_expected.to be_owned_by 'root' }
    it { is_expected.to be_grouped_into 'root' }
    it { is_expected.to be_mode 0o0000 }
  end

  # Ensure permissions on /etc/group are configured - Section 6.1.4
  describe file('/etc/group') do
    it { is_expected.to be_file }
    it { is_expected.to be_owned_by 'root' }
    it { is_expected.to be_grouped_into 'root' }
    it { is_expected.to be_mode 0o0644 }
  end

  # Ensure Permissions on /etc/gshadow are configured - Section 6.1.5
  describe file('/etc/gshadow') do
    it { is_expected.to be_file }
    it { is_expected.to be_owned_by 'root' }
    it { is_expected.to be_grouped_into 'root' }
    it { is_expected.to be_mode 0o0000 }
  end

  # Ensure permissions on /etc/passwd- are configured - Section 6.1.6
  describe file('/etc/passwd-') do
    it { is_expected.to be_file }
    it { is_expected.to be_owned_by 'root' }
    it { is_expected.to be_grouped_into 'root' }
    it { is_expected.to be_mode 0o0644 }
  end

  # Ensure permissions on /etc/shadow- are configured - Section 6.1.7
  describe file('/etc/shadow-') do
    it { is_expected.to be_file }
    it { is_expected.to be_owned_by 'root' }
    it { is_expected.to be_grouped_into 'root' }
    it { is_expected.to be_mode 0o0000 }
  end

  # Ensure permissions on /etc/group- are configured - Section 6.1.8
  describe file('/etc/group-') do
    it { is_expected.to be_file }
    it { is_expected.to be_owned_by 'root' }
    it { is_expected.to be_grouped_into 'root' }
    it { is_expected.to be_mode 0o0644 }
  end

  # Ensure permissions on /etc/gshadow- are configured - Section 6.1.9
  describe file('/etc/gshadow-') do
    it { is_expected.to be_file }
    it { is_expected.to be_owned_by 'root' }
    it { is_expected.to be_grouped_into 'root' }
    it { is_expected.to be_mode 0o0000 }
  end
end
