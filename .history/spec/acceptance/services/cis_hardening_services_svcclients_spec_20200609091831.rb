require 'spec_helper_acceptance'

# Ensure NIS CLient is not installed - Section 2.3.1
describe package('ypbind') do
    it { sh}
end