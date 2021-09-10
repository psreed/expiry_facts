# expiry_facts

## Table of Contents

1. [Description](#description)
1. [Setup - The basics of getting started with expiry_facts](#setup)
1. [Facts - The Facts provided by this module](#Facts)
1. [Warnings - Warnings and Bad Practices](#Warnings)

## Description

Interested in knowning when your RPM GPG Keys or Puppet Certificates are going to expire? This module is for you.
This is an extremely small module which only provides a few external facts at the moment (no manifests at all, just 3 external fact files).
You can use these facts in reports or simply create classifications groups to show when your certificates are going to expire.

## Setup

Simply add this module to your Puppetfile, trigger a code deploy and you're good to go.
The next time Puppet runs on your endpoints, you will see the facts provided by this module.

Example Puppetfile Entry:

```
## GPG Expiry warnings
mod 'psreed-expiry_facts',
  :git    => 'https://github.com/psreed/expiry_facts.git',
  :branch => 'main'
```

## Facts

### The following facts are provided by adding this module to your Puppfile

#### puppet_cert

This fact will show on Windows and Linux hosts.
Tested with Windows 10, CentOS/RedHat EL 7, EL 8 and Ubuntu 20.04.

puppet_cert fact example:

```
{
  "end_date" : "2026-02-03T01:47:11",
  "expiry_under_6_months" : false,
  "hostcert" : "C:/ProgramData/PuppetLabs/puppet/etc/ssl/certs/somehostname.pem",
  "start_date" : "2021-02-03T01:47:11"
}
```

#### gpg_expiry_warnings

This fact will show the number of RPM GPG keys that have either already expired or will be expiring within the next 6 months.

#### gpg_key_count

This is the number of RPM GPG keys current present in the system.

#### gpg_rpm_gpg_dir

This fact shows the current working directory for the RPM GPG keys

#### gpg_pub_keys

This fact shows information on all the currently available facts in the gpg_rpm_gpg_dir.

gpg_pub_keys example:

```
{
  "1054B7A24BD6EC30" : {
    "expiry_date" : "Wed Jan 4 19:06:37 EST 2017",
    "expiry_under_6_months" : true,
    "key_info" : "pub:e:4096:1:1054B7A24BD6EC30:1278720832:1483574797::-:Puppet Labs Release Key (Puppet Labs Release Key) <info@puppetlabs.com>:",
    "key_status" : "EXPIRED"
  },
  "24C6A8A7F4A80EB5" : {
    "expiry_date" : "",
    "expiry_under_6_months" : "",
    "key_info" : "pub:-:4096:1:24C6A8A7F4A80EB5:1403518795:::-:CentOS-7 Key (CentOS 7 Official Signing Key) <security@centos.org>:",
    "key_status" : "-"
  },
  "4528B6CD9E61EF26" : {
    "expiry_date" : "Sun Apr 6 17:39:22 EDT 2025",
    "expiry_under_6_months" : false,
    "key_info" : "pub:-:4096:1:4528B6CD9E61EF26:1554759562:1743975562::-:Puppet, Inc. Release Key (Puppet, Inc. Release Key) <release@puppet.com>:",
    "key_status" : "-"
  }
}
```

## Warnings

#### Warnings and Bad Practices

This was a very quickly developed module to get facts. Currently there are some hardcoded paths and things that are completely against best practice coding, but it works.

The current hardcoded paths and general bad things are:

1. Path to Puppet on Windows: "C:\Program Files\Puppet Labs\Puppet\bin\puppet.bat"
1. RPM GPG key check has no testing for OS. It will still run on apt-get platforms (ie, Debian, Ubuntu, etc), but the gpg\_\* facts will just be blank. No real harm, but there should be code to simply skip and not output these facts.
