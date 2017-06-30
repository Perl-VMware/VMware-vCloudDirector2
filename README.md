[![Build Status](https://travis-ci.org/Perl-VMware/perl-VMware-vCloudDirector.svg?branch=master)](https://travis-ci.org/Perl-VMware/perl-VMware-vCloudDirector)
[![Kwalitee status](http://cpants.cpanauthors.org/dist/VMware-vCloudDirector.png)](http://cpants.charsbar.org/dist/overview/VMware-vCloudDirector)
[![GitHub issues](https://img.shields.io/github/issues/Perl-VMware/perl-VMware-vCloudDirector.svg)](https://github.com/Perl-VMware/perl-VMware-vCloudDirector/issues)
[![GitHub tag](https://img.shields.io/github/tag/Perl-VMware/perl-VMware-vCloudDirector.svg)]()
[![Cpan license](https://img.shields.io/cpan/l/VMware-vCloudDirector.svg)](https://metacpan.org/release/VMware-vCloudDirector)
[![Cpan version](https://img.shields.io/cpan/v/VMware-vCloudDirector.svg)](https://metacpan.org/release/VMware-vCloudDirector)

# NAME

VMware::vCloudDirector - Interface to VMWare vCloud Directory REST API

# VERSION

version 0.006

# SYNOPSIS

    # THIS IS AT AN EARLY STAGE OF DEVELOPMENT - PROTOTYPING REALLY
    # IT MAY CHANGE DRAMATICALLY OR EAT YOUR DATA.

    use VMware::vCloudDirector

    my $vcd = VMware::vCloudDirector->new(
        hostname   => $host,
        username   => $user,
        password   => $pass,
        orgname    => $org,
        ssl_verify => 0,
    );
    my @org_list = $vcd->org_list;

## Attributes

### hostname

Hostname of the vCloud server.  Must have a vCloud instance listening for https
on port 443.

### username

Username to use to login to vCloud server.

### password

Password to use to login to vCloud server.

### orgname

Org name to use to login to vCloud server - this defaults to `System`.

### timeout

Command timeout in seconds.  Defaults to 120.

### default\_accept\_header

The default MIME types to accept.  This is automatically set based on the
information received back from the API versions.

### ssl\_verify

Whether to do standard SSL certificate verification.  Defaults to set.

### ssl\_ca\_file

The SSL CA set to trust packaged in a file.  This defaults to those set in the
[Mozilla::CA](https://metacpan.org/pod/Mozilla::CA)

## debug

Set debug level.  The higher the debug level, the more chatter is exposed.

Defaults to 0 (no output) unless the environment variable `VCLOUD_API_DEBUG`
is set to something that is non-zero.  Picked up at create time in `BUILD()`

# DESCRIPTION

Thinish wrapper of the VMware vCloud Director REST API.

THIS IS AT AN EARLY STAGE OF DEVELOPMENT - PROTOTYPING REALLY - AND MAY CHANGE
DRAMATICALLY OR EAT YOUR DATA.

The target application is to read information from a vCloud instance, so the
ability to change or write data to the vCloud system has not been implemented
as yet...

# AUTHOR

Nigel Metheringham <nigelm@cpan.org>

# COPYRIGHT AND LICENSE

This software is copyright (c) 2017 by Nigel Metheringham.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.
