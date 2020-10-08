# @summary A manifest to configure Networking parameters according to CIS Hardening Guidelines
#
# Section 3.1
#
# @example
#   include cis_hardening::network::netparams
class cis_hardening::network::netparams {

  # Restart sysctl section to enact changes
  exec { 'restart_sysctl':
    path    => '/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin',
    command => '/sbin/sysctl -p',
  }

  # Add Parameters to Existing sysctl.conf File
  # Ensure IP Forwarding is disabled - Section 3.1.1
  file_line { 'ipforward_disable':
    ensure => 'present',
    path   => '/etc/sysctl.d/99-sysctl.conf',
    line   => 'net.ipv4.ip_forward = 0',
    notify => Exec['restart_sysctl'],
  }

  # Ensure packet redirect sending is disabled - Section 3.1.2
  file_line { 'redirect_all_disable':
    ensure => 'present',
    path   => '/etc/sysctl.d/99-sysctl.conf',
    line   => 'net.ipv4.conf.all.send_redirects = 0',
    notify => Exec['restart_sysctl'],
  }

  file_line { 'redirect_default_disable':
    ensure => 'present',
    path   => '/etc/sysctl.d/99-sysctl.conf',
    line   => 'net.ipv4.conf.default.send_redirects = 0',
    notify => Exec['restart_sysctl'],
  }

  # Network Parameters for Host and Router - Section 3.2
  # Ensure source routed packets are not accepted - Section 3.2.1
  file_line { 'source_route_all':
    ensure => 'present',
    path   => '/etc/sysctl.d/99-sysctl.conf',
    line   => 'net.ipv4.conf.all.accept_source_route = 0',
    notify => Exec['restart_sysctl'],
  }

  file_line { 'source_route_default':
    ensure => 'present',
    path   => '/etc/sysctl.d/99-sysctl.conf',
    line   => 'net.ipv4.conf.default.accept_source_route = 0',
    notify => Exec['restart_sysctl'],
  }

  # Ensure ICMP redirects are not accepted - Section 3.2.2
  file_line  {'icmp_redirects_all':
    ensure => 'present',
    path   => '/etc/sysctl.d/99-sysctl.conf',
    line   => 'net.ipv4.conf.all.accept_redirects = 0',
    notify => Exec['restart_sysctl'],
  }

  file_line { 'icmp_redirects_default':
    ensure => 'present',
    path   => '/etc/sysctl.d/99-sysctl.conf',
    line   => 'net.ipv4.conf.default.accept_redirects = 0',
    notify => Exec['restart_sysctl'],
  }

  # Ensure secure ICMP redirects are not accepted - Section 3.2.3
  file_line { 'icmp_redirects_all_secure':
    ensure => 'present',
    path   => '/etc/sysctl.d/99-sysctl.conf',
    line   => 'net.ipv4.conf.all.secure_redirects = 0',
    notify => Exec['restart_sysctl'],
  }

  file_line { 'icmp_redirects_default_secure':
    ensure => 'present',
    path   => '/etc/sysctl.d/99-sysctl.conf',
    line   => 'net.ipv4.conf.default.secure_redirects = 0',
    notify => Exec['restart_sysctl'],
  }

  # Ensure suspicious packets are logged - Section 3.2.4
  file_line { 'log_suspicious_all':
    ensure => 'present',
    path   => '/etc/sysctl.d/99-sysctl.conf',
    line   => 'net.ipv4.conf.all.log_martians = 1',
    notify => Exec['restart_sysctl'],
  }

  file_line { 'log_suspicious_default':
    ensure => 'present',
    path   => '/etc/sysctl.d/99-sysctl.conf',
    line   => 'net.ipv4.conf.default.log_martians = 1',
    notify => Exec['restart_sysctl'],
  }

  # Ensure broadcast ICMP requests are ignored - Section 3.2.5
  file_line { 'ignore_broadcasts':
    ensure => 'present',
    path   => '/etc/sysctl.d/99-sysctl.conf',
    line   => 'net.ipv4.icmp_echo_ignore_broadcasts = 1',
    notify => Exec['restart_sysctl'],
  }

  # Ensure bogus ICMP responses are ignored - Section 3.2.6
  file_line { 'ignore_bogus_icmp_errors':
    ensure => 'present',
    path   => '/etc/sysctl.d/99-sysctl.conf',
    line   => 'net.ipv4.icmp_ignore_bogus_error_responses = 1',
    notify => Exec['restart_sysctl'],
  }

  # Ensure reverse path filtering is enabled - Section 3.2.7
  file_line { 'reverse_path_filter_all':
    ensure => 'present',
    path   => '/etc/sysctl.d/99-sysctl.conf',
    line   => 'net.ipv4.conf.all.rp_filter = 1',
    notify => Exec['restart_sysctl'],
  }

  file_line { 'reverse_path_filter_default':
    ensure => 'present',
    path   => '/etc/sysctl.d/99-sysctl.conf',
    line   => 'net.ipv4.conf.default.rp_filter = 1',
    notify => Exec['restart_sysctl'],
  }

  # Ensure TCP SYN Cookies is enabled - Section 3.2.8
  file_line { 'tcp_syncookies':
    ensure => 'present',
    path   => '/etc/sysctl.d/99-sysctl.conf',
    line   => 'net.ipv4.tcp_syncookies = 1',
    notify => Exec['restart_sysctl'],
  }
}
