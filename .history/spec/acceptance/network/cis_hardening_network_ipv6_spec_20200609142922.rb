require 'spec_helper_acceptance'

describe 'cis_hardening_auth_accounts class' do
  context 'default parameters' do
    it 'behaves idempotently' do
      idempotent_apply(pp)
    end
  end
end

# Ensure IPv6 router advertisements are not accepted - Section 3.3.1
# Ensure IPv6 redirets are not accepted - Section 3.3.2
describe file ( '/etc/sysctl.d/99-sysctl.conf' ) do
    it { should be_symlink }
    it { should be_owned_by 'root' }
    it { should be_grouped_into 'root' }
    its (:content) { should match /net.ipv6.conf.all.accept_ra = 0/ }
    its (:content) { should match /net.ipv6.conf.default.accept_ra = 0/ }
    its (:content) { should match /net.ipv6.conf.all.accept_redirects = 0/ }
    its (:content) { should match /net.ipv6.conf.default.accept_redirects = 0/ }
end