# Changelog

All notable changes to this project will be documented in this file.

## Release 0.1.0

**Features**

Standard RHEL/CentOS CIS Hardening
- Currently only supports version 7 of the OS

**Bugfixes**

No currently known bugs

**Known Issues**

No currently known issues

**TODO**

Implement types/providers to find state on:
- Files that are SUID or GUID
- Users that have incorrect or elevated UIDs
- Specified Privilege Escalation roles remain static

auth/accounts.pp:             # TODO: Write a fact to detect state upon which to operate.
logaudit/logging.pp:          # TODO: automate process of configuring rsyslog
logaudit/accounting.pp:       # TODO: Develop a good scenario for alloting grub options via automation
network/unused_protocols.pp:  # TODO: Create fact to find wireless interfaces for disabling
maint/usergroups.pp:          # TODO: Write fact to Check for group and world writable directories that are owned by root - 6.2.4
maint/usergroups.pp:          # TODO: Write fact to Ensure all User home directories exist - 6.2.5
maint/usergroups.pp:          # TODO: Write a fact to ensure users' home directory permissions are 750 or more restrictive - 6.2.6
maint/usergroups.pp:          # TODO: Write a fact to ensure users own their home directories - 6.2.7
maint/usergroups.pp:          # TODO: Write a fact to ensure users' dotfiles are not group or world writable - 6.2.8
maint/usergroups.pp:          # TODO: Write a fact to ensure no user has a .forward file - 6.2.9
maint/usergroups.pp:          # TODO: Write a fact to ensure no user as a .netrc file - 6.2.10
maint/usergroups.pp:          # TODO: Write a fact to Ensure user's .netrc files are not group or world writable - 6.2.11
maint/usergroups.pp:          # TODO: Write a fact to ensure no users have .rhosts files - 6.2.12
maint/usergroups.pp:          # TODO: Write a fact to ensure all groups in /etc/passwd exist in /etc/group - 6.2.13
maint/usergroups.pp:          # TODO: Write a fact to ensure no duplicate UIDs exist - 6.2.14
maint/usergroups.pp:          # TODO: Write a fact to ensure no duplicate GIDs exist - 6.2.15
maint/usergroups.pp:          # TODO: Write a fact to ensure no duplicate usernames exist - 6.2.16
maint/usergroups.pp:          # TODO: Write a fact to ensure no duplicate group names exist - 6.2.17
maint/usergroups.pp:          # TODO: Write a fact to ensure shadow group is empty - 6.2.18
network/unused_protocols.pp:  # TODO: Write a fact to ensure wireless Interfaces are disabled - Section 3.1.2
setup/filesystem.pp           # TODO: Write a fact to ensure noexec,nodev,nosuid set on removable media partitions - Section 1.1.19,1.1.20,1.1.21
setup/filesydtem.pp           # TODO: Write a fact to ensure sticky bit is set on all world-writable directories - Section 1.1.22
