require 'spec_helper_acceptance'

describe 'Setup System Banners' do
  # Ensure message of the day (MOTD) is properly configured - Section 1.7.1.1,
  # Ensure permisisons on /etc/motd are configured - Section 1.7.1.4
  describe file('/etc/motd') do
    it { is_expected.to be_file }
    it { is_expected.to be_owned_by 'root' }
    it { is_expected.to be_grouped_into 'root' }
    it { is_expected.to be_mode 0o0644 }
    its(:content) { is_expected.to match %r{/Puppet/} }
  end

  # Ensure local login warning banner is configured properly - Section 1.7.1.2
  # Ensure permissions on /etc/issue are configured - Section 1.7.1.5
  describe file('/etc/issue') do
    it { is_expected.to be_file }
    it { is_expected.to be_owned_by 'root' }
    it { is_expected.to be_grouped_into 'root' }
    it { is_expected.to be_mode 0o0644 }
    its(:content) { is_expected.to match %r{/Puppet/} }
  end

  # Ensure remote login warnig banner is configured properly - Section 1.7.1.3
  # Ensure permissions on /etc/issue.net are configured - Section 1.7.1.6
  describe file('/etc/issue.net') do
    it { is_expected.to be_file }
    it { is_expected.to be_owned_by 'root' }
    it { is_expected.to be_grouped_into 'root' }
    it { is_expected.to be_mode 0o0644 }
    its(:content) { is_expected.to match %r{/Puppet/} }
  end

  # Had to get wild on this. The gdm system is not supposed to be installed so the
  # default state is for those files not to exist. So, I inverted the logic to
  # declare that if gdm isn't installed, this is what is_expected.to occur.
  context 'gdm is not installed' do
    let(:facts) do
      {
        gdm: 'absent',
      }
    end

    # Ensure GDM login banner is configured - Section 1.7.2
    describe file('/etc/dconf/profile/gdm') do
      it { is_expected.not_to be_file }
    end

    describe file('/etc/dconf/db/gdm.d/01-banner-message') do
      it { is_expected.not_to be_file }
    end
  end
end
