# @summary A manifest to configure filesystem permissions as per CIS Hardening GUidelines
#
# Section 6.1
#
# @example
#   include cis_hardening::maint::fileperms
class cis_hardening::maint::fileperms {

  # Audit System File Permissions - Section 6.1.1 
  #
  # This item requires manual execution and inspection of output. It suggests a manual 
  # inspection of all installed packages on the system, which is marginally infeasible.
  # acceptance of risk for this item is encouraged, lest Puppet runs take entirely too
  # much time and unnecessarily load the system.

  # Ensure permissions on /etc/passwd are configured - Section 6.1.2
  file { '/etc/passwd':
    ensure => 'present',
    owner  => 'root',
    group  => 'root',
    mode   => '0644',
  }

  # Ensure permissions on /etc/shadow are configured - Section 6.1.3
  file { '/etc/shadow':
    ensure => 'present',
    owner  => 'root',
    group  => 'root',
    mode   => '0000',
  }

  # Ensure permissions on /etc/group are configured - Section 6.1.4
  file { '/etc/group':
    ensure => 'present',
    owner  => 'root',
    group  => 'root',
    mode   => '0644',
  }

  # Ensure Permissions on /etc/gshadow are configured - Section 6.1.5
  file { '/etc/gshadow':
    ensure => 'present',
    owner  => 'root',
    group  => 'root',
    mode   => '0000',
  }

  # Ensure permissions on /etc/passwd- are configured - Section 6.1.6
  file { '/etc/passwd-':
    ensure => 'present',
    owner  => 'root',
    group  => 'root',
    mode   => '0644',
  }

  # Ensure permissions on /etc/shadow- are configured - Section 6.1.7
  file { '/etc/shadow-':
    ensure => 'present',
    owner  => 'root',
    group  => 'root',
    mode   => '0000',
  }

  # Ensure permissions on /etc/group- are configured - Section 6.1.8
  file { '/etc/group-':
    ensure => 'present',
    owner  => 'root',
    group  => 'root',
    mode   => '0644',
  }

  # Ensure permissions on /etc/gshadow- are configured - Section 6.1.9
  file { '/etc/gshadow-':
    ensure => 'present',
    owner  => 'root',
    group  => 'root',
    mode   => '0000',
  }

  # Ensure no worldwritable files exist - Section 6.1.10
  #
  # NOTE: This command is a manual command with manual inspection and remediation of the output.
  # The command is resource intensive and would execute a search of the entire filesystem on every 
  # Puppet run, making the run exorbitantly long, and thus introducing overhead to the system.
  #
  # Use "find <parition> -xdev -type f -perm -0002" and manually remediate findings.

  # Ensure no unowned files or directories exist - Section 6.1.11
  #
  # NOTE: This command is a manual command with manual inspection and remedation of the output.
  #
  # Run: "sudo df --local -P |awk {'if (NR!=1) print $6'} |xargs -I '{}' find '{}' -xdev -nouser"
  # and verify no files are returned. If you would instead perfer to search individual partitions,
  # use the following command:
  #   fnd <partition> -xdev -nouser
  #
  # on each partition.
  #
  # Ensure no ungrouped files or directories exist - 6.1.12
  #
  # NOTE: This command is a manual command with manual inspection and remedation of the output.
  #
  # Run: "sudo df -l -P |awk {'if (NR!=1) print $6'} |xargs -I '{}' find '{}' -xdev -ngroup"
  # and verify no files are returned. If you would instead perfer to search individual partitions,
  # use the following command:
  #
  #   find <partition> -xdev -nogroup
  #
  # on each partition.

  # Audit SUID executables - Section 6.1.13
  #
  # NOTE: This command is a manual command with manual inspection and remedation of the output.
  #
  # Run: "sudo df --local -P |awk {'if (NR!=1) print $6'} |xargs -I '{}' find '{}' -xdev -type f -perm -4000"
  # and verify no files are returned. If you would instead prefer to search individual paritions, use the 
  # following command:
  #
  # find <partition> -xdev -type f -perm 4000
  #
  # on each partition.

  # Audit SGID executables - Section 6.1.14
  #
  # NOTE: This command is a manual command with manual inspection and remedation of the output.
  #
  # Run: "sudo df --local -P |awk {'if (NR!=1) print $6'} |xargs -I '{}' find '{}' -xdev -type f -perm -2000"
  # and verify no files are returned. If you would instead prefer to search individual paritions, use the 
  # following command:
  #
  # find <partition> -xdev -type f -perm 2000
  #
  # on each partition.
}
