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

  # Ensure Package Manager Repositories are Configured - Section 1.2.2
  #
  # Run "yum repolist" to retrieve the full list of currently configured Repositories.
  # Manually compare against site policy

  # Ensure gpgcheck is globally activated - Section 1.2.3
  file_line { 'gpgcheck':
    ensure => 'present',
    path   => '/etc/yum.conf',
    line   => 'gpgcheck=1',
    match  => '^gpgcheck\=',
  }

  # Ensure RedHat Subscription Manager connection is configured - Section 1.2.4
  # CIS lists this as a manual process. Institutional specifics
  # around RHSM can be checked, but will be unique to each
  # implementation.
  # TODO: Find a method to allow for ad-hoc configuration
  # post-provisioning

  # Disable the RHNSD daemon - Section 1.2.5
  service { 'rhnsd':
    ensure     => 'stopped',
    enable     => false,
    hasstatus  => true,
    hasrestart => true,
  }
}
