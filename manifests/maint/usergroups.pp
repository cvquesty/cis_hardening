# @summary A manifest to configure user and group settings according to CIS Hardening Guidelines
#
# Section 6.2
#
# @example
#   include cis_hardening::maint::usergroups
class cis_hardening::maint::usergroups {

  # Ensure password fields are not empty - Section 6.2.1
  #
  # NOTE: NOTE: This command is a manual command with manual inspection and remedation of the output.
  #
  # Run the following command and verify that no output is returned:
  #
  # cat /etc/shadow | awk -F: '($2 == "") { print $1 " does not have a password"}'
  #
  # If any accounts are returned, lock the account until it can be determined why it does not have a
  # password:
  #
  # passwd -l <username> 
  #

  # Items 6.2.2 through 6.2.19 are widely variant from site to site, and specific guidance needs to 
  # be given in regards to userspace pathing and ownerships within home directories.
  #
  # 1. Items will change if in IAM
  # 2. Items will change if pam_mkhomedir is used
  # 3. Users may or may not be administrative in nature
  # 4. Users may be service accounts.
  #
  # Ensure that site guidelines are explicitly spelled out, and determine the correct approach.

}
