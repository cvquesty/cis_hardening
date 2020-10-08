require 'spec_helper_acceptance'

# Ensure permissions on /etc/passwd are configured - Section 6.1.2
describe file('/etc/passwd') do
    it { should be_file }
    it { should be_owned_by 'root' }
    it { should be_grouped_into 'root' }
    it { should be_mode 644 }
end

# Ensure permissions on /etc/shadow are configured - Section 6.1.3
describe file('/etc/shadow') do
    it { should be_file }
    it { should be_owned_by 'root' }
    it { should be_grouped_into 'root' }
    it { should be_mode 000 }
end

# Ensure permissions on /etc/group are configured - Section 6.1.4
describe file('/etc/group') do
    it { should be_file }
    it { should be_owned_by 'root' }
    it { should be_grouped_into 'root' }
    it { should be_mode 644 }
end

# Ensure Permissions on /etc/gshadow are configured - Section 6.1.5
describe file('/etc/gshadow') do
    it { should be_file }
    it { should be_owned_by 'root' }
    it { should be_grouped_into 'root' }
    it { should be_mode 000 }
end

# Ensure permissions on /etc/passwd- are configured - Section 6.1.6
describe file('/etc/passwd-') do
    it { should be_file }
    it { should be_owned_by 'root' }
    it { should be_grouped_into 'root' }
    it { should be_mode 644 }
end

# Ensure permissions on /etc/shadow- are configured - Section 6.1.7
describe file('/etc/shadow-') do
    it { should be_file }
    it { should be_owned_by 'root' }
    it { should be_grouped_into 'root' }
    it { should be_mode 000 }
end

# Ensure permissions on /etc/group- are configured - Section 6.1.8
describe file('/etc/group-') do
    it { should be_file }
    it { should be_owned_by 'root' }
    it { should be_grouped_into 'root' }
    it { should be_mode 644 }
end

# Ensure permissions on /etc/gshadow- are configured - Section 6.1.9