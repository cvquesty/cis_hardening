require 'spec_helper_acceptance'

describe 'cis_hardening_setup class' do
  context 'default parameters' do
    it 'behaves idempotently' do
      idempotent_apply(pp)
    end
  end
end
