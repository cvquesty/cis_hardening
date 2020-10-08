require 'spec_helper_acceptance'

# Ensure permissions on /etc/ssh/sshd_config are configured - Section 5.2.1
# Set sshd_config Options - Section 5.2.2
# Set SSH LogLevel to INFO - Section 5.2.3
# Ensure SSH X11 Forwarding is disabled - Section 5.2.4
# Ensure SSH MaxAuthTries is set to 4 or less - Section 5.2.5
# Ensure SSH IgnoreRhosts is enabled - Section 5.2.6
# Ensure SSH HostBased Authentication is Disabled - Section 5.2.7
# Ensure SSH Root Login is Disabled - Section 5.2.8
# Ensure PermitEmptyPasswords is Disabled - Section 5.2.9
describe file('/etc/ssh/sshd_config') do
  it do
    is_expected.to be_file
    is_expected.to be_owned_by 'root'
    is_expected.to be_grouped_into 'root'
    is_expected.to be_mode 600
    is_expected.to contain 'Protocol 2'
    is_expected.to contain 'LogLevel INFO'
    is_expected.to contain 'X11Forwarding no'
    is_expected.to contain 'MaxAuthTries 4'
    is_expected.to contain 'IgnoreRhosts yes'
    is_expected.to contain 'HostbasedAuthentication no'
    is_expected.to contain 'PermitRootLogin no'
    is_expected.to contain 'PermitEmptyPasswords no'
  end
end


