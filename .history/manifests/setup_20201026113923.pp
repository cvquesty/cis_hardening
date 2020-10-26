# @summary A manifest to configure initial hardening according to CIS
# CIS hardening guidelines
#
# Section 1 - Initial Setup
#
# Enforces CIS v. 3.0.0 recommendations for initial setup according to published 
# hardening guidelines for CentOS 7.x systems
#
class cis_hardening::setup {

  include cis_hardening::setup::filesystem        # Section 1.1 - Filesystem Configuration
  include cis_hardening::setup::updates           # Section 1.2 - Configure Software Updates
  include cis_hardening::setup::sudo              # Section 1.3 - Configure Sudo
  include cis_hardening::setup::fim               # Section 1.4 - Filesystem Integrity Checking
  include cis_hardening::setup::secboot           # Section 1.5 - Secure Boot Settings
  include cis_hardening::setup::prochardening     # Section 1.6 - Additional Process Hardening
  include cis_hardening::setup::accessctl         # Section 1.7 - Mandatory Access Control

  include cis_hardening::setup::banners


}
