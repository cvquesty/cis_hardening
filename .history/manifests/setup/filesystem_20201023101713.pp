# @summary A manifest to set filesystem configurations according to CIS hardening guidelines
#
# Section 1.1 - Filesystem Configuration
#
# @example
#   include cis_hardening::setup::filesystem
class cis_hardening::setup::filesystem {
  
  # Disable unused Filesystems - Section 1.1.1

  # Create CIS.conf to hold CIS specified filesystem configurations
  file { '/etc/modprobe.d/CIS.conf':
    ensure => 'file',
    owner  => 'root',
    group  => 'root',
    mode   => '0644',
  }

  # Ensure mounting of cramfs filesystems is disabled - Section 1.1.1.1
  file_line { 'cramfs_disable':
    ensure  => 'present',
    path    => '/etc/modprobe.d/CIS.conf',
    line    => 'install cramfs /bin/true',
    require => File['/etc/modprobe.d/CIS.conf'],
  }

  # Ensure mounting of squashfs filesystems is disabled - Section 1.1.1.2
  file_line { 'squashfs_disable':
    ensure  => 'present',
    path    => '/etc/modprobe.d/CIS.conf',
    line    => 'install squashfs /bin/true',
    require => File['/etc/modprobe.d/CIS.conf'],
  }

  # Ensure mounting of udf Filesystems is disabled - Section 1.1.1.3
  file_line { 'udf_disable':
    ensure  => 'present',
    path    => '/etc/modprobe.d/CIS.conf',
    line    => 'install udf /bin/true',
    require => File['/etc/modprobe.d/CIS.conf'],
  }

  # Ensure mounting of FAT filesystems (vfat) is disabled - Section 1.1.1.4
  file_line { 'vfat_disable':
    ensure  => 'present',
    path    => '/etc/modprobe.d/CIS.conf',
    line    => 'install vfat /bin/true',
    require => File['/etc/modprobe.d/CIS.conf'],
  }

  file_line { 'fat_disable':
    ensure  => 'present',
    path    => '/etc/modprobe.d/CIS.conf',
    line    => 'install fat /bin/true',
    require => File['/etc/modprobe.d/CIS.conf'],
  }

  file_line { 'msdos_disable':
    ensure  => 'present',
    path    => '/etc/modprobe.d/CIS.conf',
    line    => 'install msdos /bin/true',
    require => File['/etc/modprobe.d/CIS.conf'],
  }

  # Ensure /tmp is configured - Section 1.1.2
  # Ensure nodev option set on /tmp partition - Section 1.1.3
  # Ensure nosuid option set on /tmp partition - Section 1.1.4
  # Ensure noexec option set on /tmp partition - Section 1.1.5
  # TODO: tmpfs mounting is touchy and can affect an existing infrastructure. We have
  # opted to 

  # Section 1.1.2
  exec { 'checktmp_part':
    path    => '/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin',
    command => 'logger -p crit "Partition /tmp not on own parittion!"',
    onlyif  => 'test ! "mount | grep /tmp" ',
  }

  # Section 1.1.3
    exec { 'chktmp_noexec':
    path    => '/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin',
    command => 'logger -p crit "Filesystem /tmp is not set noexec"',
    onlyif  => 'test ! mount |grep /tmp |grep noexec',
  }

  # Section 1.1.4
  exec { 'chktmp_nodev':
    path    => '/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin',
    command => 'logger -p crit "Partition /tmp is not set nodev!"',
    onlyif  => 'test ! mount |grep /tmp |grep nodev',
  }

  # Section 1.1.5
  exec { 'chktmp_nosuid':
    path    => '/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin',
    command => 'logger -p crit "Partition /tmp is not set nosuid"',
    onlyif  => 'test ! mount |grep /tmp |grep nosuid',
  }

  # Ensure /dev/shm is configured - Section 1.1.6
  # Ensure noexec set on /dev/shm partition - Section 1.1.7
  # Ensure nodev option set on /dev/shm partition - Secion 1.1.8
  # Ensure nosuid option set on /dev/shm partition - Section 1.1.9
  mount { '/dev/shm':
    ensure  => 'mounted',
    device  => 'tmpfs',
    options => 'defaults,noexec,nodev,nosuid,seclabel',
    fstype  => 'tmpfs',
    atboot  => '0',
    pass    => '0',
  }

  # Ensure separate partition exists for /var - Section 1.1.10
  exec { 'chkvar_part':
    path    => '/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin',
    command => 'logger -p crit "Partition /var is not on its own partition"',
    onlyif  => "test ! mount | grep -E '\s/var\s'",
  }

  # Ensure separate partition exists for /var/tmp - Section 1.1.11
  exec { 'chkvartmp_part':
    path    => '/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin',
    command => 'logger -p crit "Partition /var/tmp is not on its own partition"',
    onlyif  => 'test ! mount |grep "/var/tmp"',
  }

  # Ensure noexec option set on /var/tmp partition - Section 1.1.12
  exec { 'chkvartmp_noexec':
    path    => '/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin',
    command => 'logger -p crit "Partition /var/tmp does not have the noexec option set"',
    onlyif  => 'test ! mount |grep /var/tmp |grep noexec',
  }

  # Ensure nodev option set on /var/tmp partition - Section 1.1.13
  exec { 'chkvartmp_nodev':
    path    => '/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin',
    command => 'logger -p crit "Partition /var/tmp does not have the nodev option set"',
    onlyif  => 'test ! mount |grep /var/tmp |grep nodev',
  }

  # Ensure nosuid set on /var/tmp partition - 1.1.14
  exec { 'chkvartmp_nosuid':
    path    => '/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin',
    command => 'logger -p crit "Partition /var/tmp does not have the nosuid option set"',
    onlyif  => 'test ! mount |grep /var/tmp |grep nosuid',
  }

  # Ensure separate partition exists for /var/log - Section 1.1.15
  exec { 'chkvarlog_part':
    path    => '/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin',
    command => 'logger -p crit "Partition /var/log is not on its own parition."',
    onlyif  => 'test ! mount |grep /var/log',
  }

  # Ensure separate parition exists for /var/log/audit - Section 1.1.16
  exec { 'chkvarlogtmp_part':
    path    => '/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin',
    command => 'logger -p crit "Partition /var/log/audit is not on its own partition"',
    onlyif  => 'test ! mount |grep /var/log/audit',
  }

  # Ensure separate parittion exists for /home - Section 1.1.17
  exec { 'chkhome_part':
    path    => '/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin',
    command => 'logger -p crit "Parition /home is not on its own parition."',
    onlyif  => 'test ! mount |grep /home',
  }

  # Ensure nodev option is set on /home partition - Section 1.1.18
  exec { 'chkhome_nodev':
    path    => '/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin',
    command => 'logger -p crit "Partition /home does not have the nodev option set"',
    onlyif  => 'test ! mount |grep /home |grep nodev',
  }

  # Ensure noexec option set on removable media partitions - Section 1.1.19
  # Ensure nodev option set on removable media partitions - Section 1.1.20
  # Ensure nosuid option set on removable media paritions - Section 1.1.21
  # TODO: Write a fact to check this state

  # Ensure sticky bit is set on all world-writable directories - Section 1.1.22
  # TODO: Write a fact to check this state

  # Disable Automounting - Section 1.1.23
  service { 'autofs':
    ensure     => 'stopped',
    enable     => false,
    hasstatus  => true,
    hasrestart => true,
  }

  # Disable USB Storage - Section 1.1.24
  file { '/etc/modprobe.d/cisusbstorage.conf':
    ensure  => 'present',
    owner   => 'root',
    group   => 'root',
    mode    => '0755',
    content =>  'install usb-storage /bin/true',
  }

}
