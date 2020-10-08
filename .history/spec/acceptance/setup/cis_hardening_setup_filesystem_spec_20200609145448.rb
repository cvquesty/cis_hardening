require 'spec_helper_acceptance'

describe 'cis_hardening_setup_filesystem class' do
  context 'default parameters' do
    it 'behaves idempotently' do
      idempotent_apply(pp)
    end
  end

  # Disable unused Filesystems - Section 1.1.1
  describe file('')
end