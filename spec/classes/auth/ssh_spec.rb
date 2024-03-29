require 'spec_helper'

describe 'cis_hardening::auth::ssh' do
  on_supported_os.each do |os, os_facts|
    context "on #{os}" do
      let(:facts) { os_facts }

      # Check for default class
      it {
        is_expected.to contain_class('cis_hardening::auth::ssh')
      }

      # Ensure that Ensure permissions on /etc/ssh/sshd_config are configured - Section 5.3.1
      it {
        is_expected.to contain_file('/etc/ssh/sshd_config').with(
          'ensure' => 'file',
          'owner'  => 'root',
          'group'  => 'root',
          'mode'   => '0600',
        )
      }

      # Ensure permissions on SSH private host key files are configured - Section 5.3.2
      it {
        is_expected.to contain_exec('set_sshprivkey_perms').with(
          'path'    => '/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin',
          'command' => "find /etc/ssh -xdev -type f -name 'ssh_host_*_key' -exec chmod u-x,g-wx,o-rwx {} \\;",
        )
      }

      it {
        is_expected.to contain_exec('set_sshprivkey_owner').with(
          'path'    => '/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin',
          'command' => "find /etc/ssh -xdev -type f -name 'ssh_host_*_key' -exec chown root:ssh_keys {} \\;",
        )
      }

      # Ensure permissions on SSH public host key files are configured - Section 5.3.3
      it {
        is_expected.to contain_exec('set_sshpubkey_perms').with(
          'path'    => '/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin',
          'command' => "find /etc/ssh -xdev -type f -name 'ssh_host_*_key.pub' -exec chmod u-x,go-wx {} \\;",
        )
      }

      it {
        is_expected.to contain_exec('set_sshpubkey_owner').with(
          'path'    => '/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin',
          'command' => "find /etc/ssh -xdev -type f -name 'ssh_host_*_key.pub' -exec chown root:root {} \\;",
        )
      }

      # Ensure SSH access is limited - Section 5.3.4
      # Currently commented. Up to the discretion of the user as to whether to enable

      # Ensure that Ensure SSH LogLevel is appropriate - Section 5.3.5
      it {
        is_expected.to contain_file_line('set_ssh_loglevel').with(
          'ensure' => 'present',
          'path'   => '/etc/ssh/sshd_config',
          'line'   => 'LogLevel INFO',
          'match'  => '^LogLevel\ ',
        )
      }

      # Ensure that Ensure SSH X11 Forwarding is disabled - Section 5.3.6
      it {
        is_expected.to contain_file_line('set_x11_forwarding').with(
          'ensure' => 'present',
          'path'   => '/etc/ssh/sshd_config',
          'line'   => 'X11Forwarding no',
        )
      }

      # Ensure SSH MaxAuthTries is set to 4 or less - Section 5.3.7
      it {
        is_expected.to contain_file_line('set_ssh_maxauthtries').with(
          'ensure' => 'present',
          'path'   => '/etc/ssh/sshd_config',
          'line'   => 'MaxAuthTries 4',
          'match'  => '^MaxAuthTries\ ',
        )
      }

      # Ensure that Ensure SSH IgnoreRhosts is enabled - Section 5.3.8
      it {
        is_expected.to contain_file_line('set_ssh_ignore_rhosts').with(
          'ensure' => 'present',
          'path'   => '/etc/ssh/sshd_config',
          'line'   => 'IgnoreRhosts yes',
          'match'  => '^IgnoreRhosts\ ',
        )
      }

      # Ensure that Ensure SSH HostBased Authentication is Disabled - Section 5.3.9
      it {
        is_expected.to contain_file_line('set_hostbasedauth_off').with(
          'ensure' => 'present',
          'path'   => '/etc/ssh/sshd_config',
          'line'   => 'HostBasedAuthentication no',
          'match'  => '^HostBasedAuthentication\ ',
        )
      }

      # Ensure that Ensure SSH Root Login is Disabled - Section 5.3.10
      it {
        is_expected.to contain_file_line('set_rootlogin_no').with(
          'ensure' => 'present',
          'path'   => '/etc/ssh/sshd_config',
          'line'   => 'PermitRootLogin no',
          'match'  => '^PermitRootLogin\ ',
        )
      }

      # Ensure that Ensure PermitEmptyPasswords is Disabled - Section 5.3.11
      it {
        is_expected.to contain_file_line('set_emptypasswords_off').with(
          'ensure' => 'present',
          'path'   => '/etc/ssh/sshd_config',
          'line'   => 'PermitEmptyPasswords no',
          'match'  => '^PermitEmptyPasswords\ ',
        )
      }

      # Ensure that Ensure SSH PermitUserEnvironment is Disabled - Section 5.3.12
      it {
        is_expected.to contain_file_line('set_permituserenv_off').with(
          'ensure' => 'present',
          'path'   => '/etc/ssh/sshd_config',
          'line'   => 'PermitUserEnvironment no',
          'match'  => '^PermitUserEnvironment\ ',
        )
      }

      # Ensure only strong ciphers are used - Section 5.3.13
      it {
        is_expected.to contain_file_line('set_ssh_ciphers').with(
          'ensure' => 'present',
          'path'   => '/etc/ssh/sshd_config',
          'line'   => 'Ciphers chacha20-poly1305@openssh.com,aes256-gcm@openssh.com,aes128-gcm@openssh.com,aes256-ctr,aes192-ctr,aes128-ctr',
          'match'  => '^Ciphers\ ',
        )
      }

      # Ensure only strong MAC algorithms are used - Section 5.3.14
      it {
        is_expected.to contain_file_line('set_ssh_macs').with(
          'ensure' => 'present',
          'path'   => '/etc/ssh/sshd_config',
          'line'   => 'MACs hmac-sha2-512-etm@openssh.com,hmac-sha2-256-etm@openssh.com,hmac-sha2-512,hmac-sha2-256',
          'match'  => '^MACs\ ',
        )
      }

      # Ensure only strong Key Exchange algorithms are used - Section 5.3.15
      it {
        is_expected.to contain_file_line('ssh_keyexchange_algos').with(
          'ensure' => 'present',
          'path'   => '/etc/ssh/sshd_config',
          'line'   => 'KexAlgorithms curve25519-sha256,curve25519-sha256@libssh.org,diffie-hellman-group14-sha256,diffie-hellman-group16-sha512,diffie-hellman-group18-sha512,ecdh-sha2-nistp521,ecdh-sha2-nistp384,ecdh-sha2-nistp256,diffie-hellman-group-exchange-sha256',
          'match'  => '^KexAlgorithms\ ',
        )
      }

      # Ensure that Ensure SSH Idle Timeout Interval is configured - Section 5.3.16
      it {
        is_expected.to contain_file_line('client_alive_interval').with(
          'ensure' => 'present',
          'path'   => '/etc/ssh/sshd_config',
          'line'   => 'ClientAliveInterval 300',
          'match'  => '^ClientAliveInterval\ ',
        )
      }

      # Ensure that Ensure SSH LoginGraceTime is set to One Minute or Less - Section 5.3.17
      it {
        is_expected.to contain_file_line('login_grace_time').with(
          'ensure' => 'present',
          'path'   => '/etc/ssh/sshd_config',
          'line'   => 'LoginGraceTime 60',
          'match'  => '^LoginGraceTime\ ',
        )
      }

      # Ensure SSH Warning Banner is Configured - Section 5.3.18
      it {
        is_expected.to contain_file_line('set_ssh_banner').with(
          'ensure' => 'present',
          'path'   => '/etc/ssh/sshd_config',
          'line'   => 'Banner /etc/issue.net',
          'match'  => '^Banner\ ',
        )
      }

      # Ensure SSH PAM is enabled - Section 5.3.19
      it {
        is_expected.to contain_file_line('set_ssh_pam').with(
          'ensure' => 'present',
          'path'   => '/etc/ssh/sshd_config',
          'line'   => 'UsePAM yes',
          'match'  => '^UsePAM\ ',
        )
      }

      # Ensure SSH AllowTcpForwarding is disabled - Section 5.3.20
      it {
        is_expected.to contain_file_line('ssh_allowtcpforwarding').with(
          'ensure' => 'present',
          'path'   => '/etc/ssh/sshd_config',
          'line'   => 'allowtcpforwarding no',
          'match'  => '^allowtcpforwarding\ ',
        )
      }

      # Ensure SSH MaxStartups is configured - Section 5.3.21
      it {
        is_expected.to contain_file_line('ssh_maxstartups').with(
          'ensure' => 'present',
          'path'   => '/etc/ssh/sshd_config',
          'line'   => 'maxstartups 10:30:60',
          'match'  => '^maxstartups\ ',
        )
      }

      # Ensure SSH MaxSessions is limited - Section 5.3.22
      it {
        is_expected.to contain_file_line('ssh_maxsessions').with(
          'ensure' => 'present',
          'path'   => '/etc/ssh/sshd_config',
          'line'   => 'maxsessions 10',
          'match'  => '^maxsessions\ ',
        )
      }

      # Ensure manifest compiles with all dependencies
      it {
        is_expected.to compile.with_all_deps
      }
    end
  end
end
