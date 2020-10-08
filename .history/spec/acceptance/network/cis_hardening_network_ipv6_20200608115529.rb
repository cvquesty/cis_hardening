require 'spec_helper_acceptance'

# Ensure IPv6 router advertisements are not accepted - Section 3.3.1
describe file ( '/etc/sysctl.d/99-sysctl.conf') 