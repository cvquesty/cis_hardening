require 'spec_helper'

describe 'cis_hardening::setup::filesystem' do
  on_supported_os.each do |os, os_facts|
    context "on #{os}" do
      let(:facts) { os_facts }

      # Check for default class
      it {
        is_expected.to contain_class('cis_hardening::setup::filesystem')
      }

      # Disable unused Filesystems - Section 1.1.1
      # Create CIS.conf to hold CIS specified filesystem configurations
      it {
        is_expected.to contain_file('/etc/modprobe.d/CIS.conf').with(
          'ensure' => 'file',
          'owner'  => 'root',
          'group'  => 'root',
          'mode'   => '0644',
        )
      }

      # Ensure mounting of cramfs filesystems is disabled - Section 1.1.1.1
      it {
        is_expected.to contain_file_line('cramfs_disable').with(
          'ensure' => 'present',
          'path'   => '/etc/modprobe.d/CIS.conf',
          'line'   => 'install cramfs /bin/true',
        ).that_requires('File[/etc/modprobe.d/CIS.conf]')
      }
      
      # Ensure mounting of squashfs filesystems is disabled - Section 1.1.1.2
      it {
        is_expected.to contain_file_line('squashfs_disable').with(
          'ensure' => 'present',
          'path'   => '/etc/modprobe.d/CIS.conf',
          'line'   => 'install squashfs /bin/true',
        ).that_requires('File[/etc/modprobe.d/CIS.conf]')
      }

      # Ensure mounting of udf filesystem is disabled - Section 1.1.1.3
      it {
        is_expected.to contain_file_line('udf_disable').with(
          'ensure' => 'present',
          'path'   => '/etc/modprobe.d/CIS.conf',
          'line'   => 'install udf /bin/true',
        ).that_requires('File[/etc/modprobe.d/CIS.conf]')
      }

      # Ensure mounting of FAT filesystems (vfat) is disabled - Section 1.1.1.4
      it {
        is_expected.to contain_file_line('vfat_disable').with(
          'ensure' => 'present',
          'path'   => '/etc/modprobe.d/CIS.conf',
          'line'   => 'install vfat /bin/true',
        ).that_requires('File[/etc/modprobe.d/CIS.conf]')
      }

      it {
        is_expected.to contain_file_line('fat_disable').with(
          'ensure' => 'present',
          'path'   => '/etc/modprobe.d/CIS.conf',
          'line'   => 'install fat /bin/true',
        ).that_requires('File[/etc/modprobe.d/CIS.conf]')
      }

      it {
        is_expected.to contain_file_line('msdos_disable').with(
          'ensure' => 'present',
          'path'   => '/etc/modprobe.d/CIS.conf',
          'line'   => 'install msdos /bin/true',
        ).that_requires('File[/etc/modprobe.d/CIS.conf]')
      }
      
      # Ensure nosuid option set on /tmp partition - Section 1.1.4
      # Ensure noexec option set on /tmp partition - Section 1.1.5

      # Ensure /tmp is configured - Section 1.1.2
      it {
        is_expected.to contain_exec('checktmp_part').with(
          'path'    => '/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin',
          'command' => 'logger -p crit "Partition /tmp not on own parittion!"',
          'onlyif'  => "test ! 'mount | grep -E '\s/tmp\s'",
        )
      }

      # Ensure nodev option set on /tmp partition - Section 1.1.3
      it {
        is_expected.to contain_exec('chktmp_nodev').with(
          'path'    => '/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin',
          'command' => 'logger -p crit "Partition /tmp is not set nodev!"',
          'onlyif'  => 'test ! mount |grep /tmp |grep nodev',
        )
      }

      # Section 1.1.4
      it {
        is_expected.to contain_exec('chktmp_nosuid').with(
          'path'    => '/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin',
          'command' => 'logger -p crit "Partition /tmp is not set nosuid"',
          'onlyif'  => 'test ! mount |grep /tmp |grep nosuid',
        )
      }

      # Section 1.1.5
      it {
        is_expected.to contain_exec('chktmp_noexec').with(
          'path'    => '/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin',
          'command' => 'logger -p crit "Filesystem /tmp is not set noexec"',
          'onlyif'  => 'test ! mount |grep /tmp |grep noexec',
        )
      }

      # Ensure separate partition exists for /var - Section 1.1.6
      it {
        is_expected.to contain_exec('chkvar_part').with(
          'path'    => '/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin',
          'command' => 'logger -p crit "Partition /var is not on its own partition"',
          'onlyif'  => 'test ! mount |grep /var',
        )
      }

      # Ensure separate partition exists for /var/tmp - Section 1.1.7
      it {
        is_expected.to contain_exec('chkvartmp_part').with(
          'path'    => '/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin',
          'command' => 'logger -p crit "Partition /var/tmp is not on its own partition"',
          'onlyif'  => 'test ! mount |grep "/var/tmp"',
        )
      }

      # Ensure nodev option set on /var/tmp partition - Section 1.1.8
      it {
        is_expected.to contain_exec('chkvartmp_nodev').with(
          'path'    => '/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin',
          'command' => 'logger -p crit "Partition /var/tmp does not have the nodev option set"',
          'onlyif'  => 'test ! mount |grep /var/tmp |grep nodev',
        )
      }

      # Ensure nosuid set on /var/tmp partition - 1.1.9
      it {
        is_expected.to contain_exec('chkvartmp_nosuid').with(
          'path'    => '/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin',
          'command' => 'logger -p crit "Partition /var/tmp does not have the nosuid option set"',
          'onlyif'  => 'test ! mount |grep /var/tmp |grep nosuid',
        )
      }

      # Ensure noexec option set on /var/tmp partition - Section 1.1.10
      it {
        is_expected.to contain_exec('chkvartmp_noexec').with(
          'path'    => '/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin',
          'command' => 'logger -p crit "Partition /var/tmp does not have the noexec option set"',
          'onlyif'  => 'test ! mount |grep /var/tmp |grep noexec',
        )
      }

      # Ensure separate partition exists for /var/log - Section 1.1.11
      it {
        is_expected.to contain_exec('chkvarlog_part').with(
          'path'    => '/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin',
          'command' => 'logger -p crit "Partition /var/log is not on its own parition."',
          'onlyif'  => 'test ! mount |grep /var/log',
        )
      }

      # Ensure separate parition exists for /var/log/audit - Section 1.1.12
      it {
        is_expected.to contain_exec('chkvarlogtmp_part').with(
          'path'    => '/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin',
          'command' => 'logger -p crit "Partition /var/log/audit is not on its own partition"',
          'onlyif'  => 'test ! mount |grep /var/log/audit',
        )
      }

      # Ensure separate parittion exists for /home - Section 1.1.13
      it {
        is_expected.to contain_exec('chkhome_part').with(
          'path'    => '/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin',
          'command' => 'logger -p crit "Parition /home is not on its own parition."',
          'onlyif'  => 'test ! mount |grep /home',
        )
      }

      # Ensure nodev option is set on /home partition - Section 1.1.14
      it {
        is_expected.to contain_exec('chkhome_nodev').with(
          'path'    => '/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin',
          'command' => 'logger -p crit "Partition /home does not have the nodev option set"',
          'onlyif'  => 'test ! mount |grep /home |grep nodev',
        )
      }

      # Ensure nodev option set on /dev/shm parition - Section 1.1.15
      it {
        is_expected.to contain_exec('chkdevshm_nodev').with(
          'path'    => '/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin',
          'command' => 'logger -p crit "Parition /dev/shm does not have the nodev option set."',
          'onlyif'  => 'test ! mount |grep /dev/shm |grep nodev',
        )
      }

      # Ensure nosuid option set on /dev/shm parition - Section 1.1.16
      it {
        is_expected.to contain_exec('chkdevshm_nosuid').with(
          'path'    => '/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin',
          'command' => 'logger -p crit "Partition /dev/shm does not have the nosuid option set."',
          'onlyif'  => 'test ! mount |grep /dev/shm |grep nosuid',
        )
      }

      # Ensure noexec option set on /dev/shm parition - Section 1.1.17
      it {
        is_expected.to contain_exec('chkdevshm_noexec').with(
          'path'    => '/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin',
          'command' => 'logger -p crit "Partition /dev/shm does not have the noexec option set."',
          'onlyif'  => 'test ! mount |grep /dev/shm |grep noexec',
        )
      }

      # Disable Automounting - Section 1.1.22
      it {
        is_expected.to contain_service('autofs').with(
          'ensure'     => 'stopped',
          'enable'     => false,
          'hasstatus'  => true,
          'hasrestart' => true,
        )
      }

      # Ensure manifest compiles with all dependencies
      it {
        is_expected.to compile.with_all_deps
      }
    end
  end
end
