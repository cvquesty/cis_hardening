# @summary A manifest to manage filesystems according to the CIS hardening Guidelines
#
# Section 1.2 - Configure Software Updates
#
# @example
#   include cis_hardening::setup::updates
class cis_hardening::setup::updates {
  
  # Ensure GPG keys are configured - Section 1.2.1
  #
  # Run "rpm -q gpg-pubkey --qf '%{name}-%{version}-%{release} --> %{summary}\n'" at the command line to
  # display the configured keys, and compare them against the latest published keys for each repo.

  # Ensure Pac

  # Ensure gpgcheck is globally activated - Section 1.2.3
  file_line { 'gpgcheck':
    ensure => 'present',
    path   => '/etc/yum.conf',
    line   => 'gpgcheck=1',
    match  => '^gpgcheck\=',
  }
}
