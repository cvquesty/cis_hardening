require 'spec_helper_acceptance'
  
  # Ensure that audit is installed
  describe package('audit') do
      it { should be_installed }
  end

  # 
    
end