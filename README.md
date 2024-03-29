# cis_hardening

Welcome to the CIS Hardening Module.
This module implements the CIS hardening benchmarks to version 2.2.0 for CentOS7
as per the CIS Benchmarks document v3.1.1 - 05-21-2021

#### Table of Contents

1. [Description](#description)

## Description

This module is a base level hardening module designed to implement the CIS hardenng
standards for CentOS7/RHEL7. There are no parameters, and there is no special calling
protocol.  As with other modules with a single entry point:

include cis_hardening

or

puppet apply -e "include cis_hardening"

The hardening guide used was the CentOS Linux 7 Benchmark guide version 2.2.0
available from the Center for Internet Security.

All manifests explicitly list out the control then the method as does the unit and
the acceptance tests.

The Unit tests are in SPEC/RSPEC using the puppet-rspec library and the acceptance
tests are in serverspec utilizing the Puppet Litmus framework.

Documentation links ar as follows

Puppet RSPEC:  https://rspec-puppet.com
ServerSPEC:    https://serverspec.org
Puppet Litmus: https://puppetlabs.github.io/litmus/

It should be noted that since the acceptance testing affects Grub and other booting
mechanisms, that the docker provisioners could not be used, as containers do not "boot"
and code to work with the Grub subsystem would not function..

In those circumstances, I utilized the vagrant provisioner to stand up full VMs to
execute acceptance testing.

# Current Allowances Needing Remediation
Currently, several checks are logging crit to STDOUT via logger.
The reason for this is multifaceted, not the least of which is load that would be
looking for SUID/GUID artifacts an other potentially noncompliant components. Since
each CIS remediation is conceptualized independently, thought is not taken to the
overall load and effect a particular procedure would have on a system.

I have a plan to implement some funcitons long-term that would perform the needed
scanning on a schedule, or at the very least via a methodology that wouldn't affect
system performance.
