require 'spec_helper_acceptance'

# Ensure message of the day (MOTD) is properly configured - Section 1.7.1.1,
# Ensure permisisons on /etc/motd are configured - Section 1.7.1.4
describe file('/etc/motd') do
    it { should be_file }
    it { should be_owned_by 'root' }
    it { should be_grouped_into 'root' }
    it { should be_mode 644 }
    its(:content) { should match /Puppet/ }
end

# Ensure local login warning banner is configured properly - Section 1.7.1.2
# Ensure permissions on /etc/issue are configured - Section 1.7.1.5
describe file('/etc/issue') do
    it { should be_file }
    it { should be_owned_by 'root' }
    it { should be_grouped_into 'root' }
    it { should be_mode 644 }
    its(:content) { should match /Puppet/ }
end

# Ensure remote login warnig banner is configured properly - Section 1.7.1.3
# Ensure permissions on /etc/issue.net are configured - Section 1.7.1.6
describe file('/etc/issue.net') do
    it { should be_file }
    it { should be_owned_by 'root' }
    it { should be_grouped_into 'root' }
    it { should be_mode 644 }
    its(:content) { should match /Puppet/ }
end

# Had to get wild on this. The file 
context 'gdm is not installed' do
  let (:facts) do
    {        
      :gdm => 'absent',
    }
  end

  # Ensure GDM login banner is configured - Section 1.7.2
  describe file('/etc/dconf/profile/gdm') do
    it { should_not be_file }
  end

  describe file('/etc/dconf/db/gdm.d/01-banner-message') do
    it { should_not be_file }
  end
end