# @summary A manifest to manage filesystems according to the CIS hardening Guidelines
#
# Section 1.2
#
# @example
#   include cis_hardening::setup::updates
class cis_hardening::setup::updates {

  # Section 1.2 - Configure Software Updates

  # Ensure Package Manager repositories are configured - Section 1.2.1
  # 
  # Execute "yum repolist" to determine configured repos to consider whether the configuration
  # matches site policy (manual).

  # Ensure GPG keys are configured - Section 1.2.2
  #
  # Run "rpm -q gpg-pubkey --qf '%{name}-%{version}-%{release} -- %{summary}\n'" at the command line to
  # display the configured keys, and compare them against the latest published keys for each repo.

  # Ensure gpgcheck is globally activated - Section 1.2.3
  file_line { 'gpgcheck':
    ensure => 'present',
    path   => '/etc/yum.conf',
    line   => 'gpgcheck=1',
    match  => '^gpgcheck\=',
  }
}
