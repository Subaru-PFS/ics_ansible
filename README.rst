This repository is for host and software configuration for PFS ICS. 
All production hosts need to be configured using this ansible playbooks, 
except for special cases, like hosts with PXE boot required.

ToC
***

- `List of definitions`_
- `Configurations to use`_
- `Definitions and requirements on modification`_
- `Support files`_

List of definitions
******

Roles
=====

:cron-apt:
  Periodic package update using cron-apt
:dnsmasq:
  'dnsmasq' service install and configuration (using ics_dnsmasq repo)
:eups:
  Install of eups, and its required python packages
:exim4:
  Configuration of exim4 as satellite host
:grafana:
  Configure grafana server (need additional configuration for auth)
:ldap:
  Configuration of ldap for account
:munin-node:
  Configuration of munin-node
:nfs:
  Mount NFSv3 for targets specified by playbook argument 'nfsv3_target'
:ntp:
  Configure NTP
:packages:
  Install packages specified by playbook argument 'packages'.
  List of packages are listed in 'packages' in site config.
  Note, openssh and ansible are required to be installed by preseeded 
  installation media.
:privca:
  Configure environment to build private CA (not to build CA)
:prometheus:
  Configure prometheus server with skeltons for targets.
:rsyslog-client:
  Configure rsyslog to push all syslog lines to site_config.rsyslog.server 
  via udp.
:rsyslog-server:
  Configure rsyslog as accepting lines via udp/tcp.
  Will not touch local output lines, so comment them out by hand if in need. 
  If site_config.rsyslog.repush is configured, will put config file to repush 
  syslog lines to after processing.
:system-accounts:
  Setup commonly required system users and groups
:virt:
  Setup libvirt environment, with PKI and br0 configuration. (reboot required)

Playbooks
======

(Note: for now, no official playbook is defined yet. Pick roles and write 
playbook referring site.yml.)

:site.yml:
  Temporary playbook for test

Configurations to use
******

Before using this set of playbooks, system administrator at each site needs to 
configure variables (`Site specific configuration`_) and inventories 
(`Sections in inventry`_) following this section. These definitions are used 
to change configurations for multiple playbooks shared among multiple sites, 
and are required to be configured per site. 

Site specific configuration
======

To switch site-wide configuration over multiple playbooks, PFS ICS ansible 
requires site\_\<domain\>.yml in group\_vars with following variables. 
This file will be read from each playbook as vars_files of 
"group\_vars/site\_{{ ansible_dns.domain }}.yml", so \<domain\> part need to 
be named as site domain name (in dnsmasq, mostly). 

- ntp: list of NTP servers
- munin\_cidr: network address range (in CIDR) which munin-node accepts connection
- cron\_apt\_hour: hour in a day of cron-apt
- dnsmasq.site: site name used for dnsmasq
- exim4\_smarthost: email relay server
- grafana.url: Grafana server publish end point URL (at grafana server)
- ldap\_uri: URI of LDAP server
- ldap\_base: LDAP base DN to be read
- mail.notice_from: Email notification from address
- mail.notice_name: Email notification mail name
- nfs.common: system wide NFS targets, list of hash 'source' and 'target'
- packages.sitewide: List of packages to be installed over site wide
- prometheus.server: Prometheus server hostname (used for metrics)
- prometheus.external_url: External publish end point URL
- prometheus.route_prefix: Path prefix for external publish end point
- prometheus.log_format: Prometheus server log format
- prometheus.storage_nfs: NFS target for local storage
- rsyslog.server: rsyslog udp/tcp server to push
- rsyslog.repush: push target at rsyslog server for after processing
- virt.nfsdisk: VM client disk storage (NFSv3)
- virt.pki.local: VM host PKI file source at local
- virt.pki.subj: PKI subjects (C,ST,L,O)

Sections in inventry
======

Following sections are used.

- (TBD)

Definitions and requirements on modification
******

To write roles and playbooks, following points are required to be considered. 

- Have version number to be installed in vars but not in task directly
- Make dependency to other roles as less as possible, and put comment of dependency

Support files
======

Folloing files are stored in "misc" directory to support non-ansible operation.

- bootstrap_mhs: Installation of eups environment

