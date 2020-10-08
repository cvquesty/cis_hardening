require 'spec_helper_acceptance'

describe 'cis_hardening class' do
  context 'default parameters' do
    it 'behaves idempotently' do
      idempotent_apply(pp)
    end
  end
end
