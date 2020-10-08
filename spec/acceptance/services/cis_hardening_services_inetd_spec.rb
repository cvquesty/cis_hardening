require 'spec_helper_acceptance'

describe ' InetD Services to disable' do
  # Ensure Chargen Services are not enabled - Section 2.1.1
  describe service('chargen-dgram') do
    it { is_expected.not_to be_enabled }
    it { is_expected.not_to be_running }
  end

  describe service('chargen-stream') do
    it { is_expected.not_to be_enabled }
    it { is_expected.not_to be_running }
  end

  # Ensure Daytime services are not enabled - Section 2.1.2
  describe service('daytime-dgram') do
    it { is_expected.not_to be_enabled }
    it { is_expected.not_to be_running }
  end

  describe service('daytime-stream') do
    it { is_expected.not_to be_enabled }
    it { is_expected.not_to be_running }
  end

  # Ensure discard services are not enabled - Section 2.1.3
  describe service('discard-dgram') do
    it { is_expected.not_to be_enabled }
    it { is_expected.not_to be_running }
  end

  describe service('discard-stream') do
    it { is_expected.not_to be_enabled }
    it { is_expected.not_to be_running }
  end

  # Ensure echo services are not enabled - Section 2.1.4
  describe service('echo-dgram') do
    it { is_expected.not_to be_enabled }
    it { is_expected.not_to be_running }
  end

  describe service('echo-stream') do
    it { is_expected.not_to be_enabled }
    it { is_expected.not_to be_running }
  end

  # Ensure time services are not enabled - Section 2.1.5
  describe service('time-dgram') do
    it { is_expected.not_to be_enabled }
    it { is_expected.not_to be_running }
  end

  describe service('time-stream') do
    it { is_expected.not_to be_enabled }
    it { is_expected.not_to be_running }
  end

  # Ensure tftp server is not enabled - Section 2.1.6
  describe service('tftp') do
    it { is_expected.not_to be_enabled }
    it { is_expected.not_to be_running }
  end

  # Ensure xinetd is not enabled - Section 2.1.7
  describe service('xinetd') do
    it { is_expected.not_to be_enabled }
    it { is_expected.not_to be_running }
  end
end
