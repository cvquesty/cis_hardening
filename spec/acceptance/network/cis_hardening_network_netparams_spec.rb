require 'spec_helper_acceptance'

describe 'Network Parameters in Sysctl' do
  describe 'cis_hardening_network_netparams class' do
    context 'default parameters' do
      it 'behaves idempotently' do
        idempotent_apply(pp)
      end
    end
  end

  # Ensure IP Forwarding is disabled - Section 3.1.1
  # Ensure packet redirect sending is disabled - Section 3.1.2
  # Ensure source routed packets are not accepted - Section 3.2.1
  # Ensure ICMP redirects are not accepted - Section 3.2.2
  # Ensure secure ICMP redirects are not accepted - Section 3.2.3
  # Ensure suspicious packets are logged - Section 3.2.4
  # Ensure broadcast ICMP requests are ignored - Section 3.2.5
  # Ensure bogus ICMP responses are ignored - Section 3.2.6
  # Ensure reverse path filtering is enabled - Section 3.2.7
  # Ensure TCP SYN Cookies is enabled - Section 3.2.8
  describe file('/etc/sysctl.d/99-sysctl.conf') do
    it { is_expected.to be_symlink }
    it { is_expected.to be_owned_by 'root' }
    it { is_expected.to be_grouped_into 'root' }
    it {
      its(:content) { is_expected.to match %r{/net.ipv4.ip_forward = 0/} }
    }
    it {
      its(:content) { is_expected.to match %r{/net.ipv4.conf.all.send_redirects = 0/} }
    }
    it {
      its(:content) { is_expected.to match %r{/net.ipv4.conf.default.send_redirects = 0/} }
    }
    it {
      its(:content) { is_expected.to match %r{/net.ipv4.conf.all.accept_source_route = 0/} }
    }
    it {
      its(:content) { is_expected.to match %r{/net.ipv4.conf.default.accept_source_route = 0/} }
    }
    it {
      its(:content) { is_expected.to match %r{/net.ipv4.conf.all.accept_redirects = 0/} }
    }
    it {
      its(:content) { is_expected.to match %r{/net.ipv4.conf.default.accept_redirects = 0/} }
    }
    it {
      its(:content) { is_expected.to match %r{/net.ipv4.conf.all.secure_redirects = 0/} }
    }
    it {
      its(:content) { is_expected.to match %r{/net.ipv4.conf.default.secure_redirects = 0/} }
    }
    it {
      its(:content) { is_expected.to match %r{/net.ipv4.conf.all.log_martians = 1/} }
    }
    it {
      its(:content) { is_expected.to match %r{/net.ipv4.conf.default.log_martians = 1/} }
    }
    it {
      its(:content) { is_expected.to match %r{/net.ipv4.icmp_echo_ignore_broadcasts = 1/} }
    }
    it {
      its(:content) { is_expected.to match %r{/net.ipv4.icmp_ignore_bogus_error_responses = 1/} }
    }
    it {
      its(:content) { is_expected.to match %r{/net.ipv4.conf.all.rp_filter = 1/} }
    }
    it {
      its(:content) { is_expected.to match %r{/net.ipv4.conf.default.rp_filter = 1/} }
    }
    it {
      its(:content) { is_expected.to match %r{/net.ipv4.tcp_syncookies = 1/} }
    }
  end
end
