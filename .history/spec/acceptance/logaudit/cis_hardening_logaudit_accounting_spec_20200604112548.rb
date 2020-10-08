require 'spec_helper_acceptance'
  
  # Ensure that audit is installed
  describe package('audit') do
      it { should be_installed }
  end

  # Make sure rules file is present
  describe file('/etc/audit/audit.rules') do
    it { is_expected.to be_file}
    it { is_expected.to be_owned_by 'root'}
    it { is_expected.to be_grouped_into 'root'}
    it { is_expected.to be_mode 640}
  end

  
    
end