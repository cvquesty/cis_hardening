require 'spec_helper_acceptance'

# Ensure IPTables is installed - Section 3.6.1
describe package('iptables') 