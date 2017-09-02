#!/bin/perl

###
## Version  Date      Author    Description
##----------------------------------------------
## 1.0      22/11/15  Shini31   1.0 stable release
## 1.1      31/12/15  Cjudith   1.1 minor release
## 1.2      09/01/16  Shini31   1.2 minor release
## 2.0      02/09/17  Jraigneau fork
####

use strict;
use warnings;

use HTTP::Request::Common qw(POST);
use LWP::UserAgent;
use JSON;
use Getopt::Long;
use Config::General;
use FindBin qw($Bin);
use lib "$Bin/../lib";

# Global Variables
my $version = "2.0";
my $change_date = "02/09/17";

# Options
my %options;
GetOptions (\%options,'host:s','state:s', 'address:s', 'channel:s', 'message:s');
my $configuration = Config::General->new($Bin.'/config.ini');
my %conf = $configuration->getall;

if (!defined($options{host})) {
    print "Need --host option\n";
    exit 1;
}

if (!defined($options{state})) {
    print "Need --state option\n";
    exit 1;
}

if (!defined($options{address})) {
    print "Need --address option\n";
    exit 1;
}

if (!defined($options{channel})) {
    print "Need --channel option\n";
    exit 1;
}

if (!defined($options{message})) {
    print "Need --message option\n";
    exit 1;
}

my $slack_payload = {
           channel => $options{channel},
           username => $conf{slack_username},
};

# Notification text
if ($options{state} eq 'UP') {
    $slack_payload->{attachments} = [
        {
            fallback => 'Host' . $options{host} . ' is ' . $options{state},
            pretext => 'Cleared',
            author_name => $options{host},
            text => '<' . $conf{centreon_url} . '/centreon/main.php?p=20202&o=hd&host_name=' . $options{host} . '|Host ' . $options{host} . ' is ' . $options{state} . '>',
            color => 'good',
            fields => [
                {
                    title => 'Host',
                    value => $options{host},
                    short => 'true',
                },
            ]
        },
    ],
} else {
    $slack_payload->{attachments} = [
        {
            fallback => 'Host ' . $options{host} . ' is ' . $options{state} . ': ' . $conf{centreon_url} . '/centreon/main.php?p=20202&o=hd&host_name=' . $options{host},
            pretext => 'New Alarm',
            author_name => $options{host},
            text => '<' . $conf{centreon_url} . '/centreon/main.php?p=20202&o=hd&host_name=' . $options{host} . '|Host ' . $options{host} . ' is ' . $options{state} . '>',
            color => 'danger',
            fields => [
                {
                    title => 'Host',
                    value => $options{host},
                    short => 'true',
                },
                {
                    title => 'Address',
                    value => $options{address},
                    short => 'true',
                },
                {
                    title => 'Message',
                    value => $options{message},
                },
            ]
        },
    ],
}



# HTTP Request
my $ua = LWP::UserAgent->new;
$ua->timeout(15);

my $req = POST($conf{slack_posturl}, ['payload' => encode_json($slack_payload)]);

my $response = $ua->request($req);

if ($response->is_success) {
    exit(0);
} else {
  die $response->status_line;
}