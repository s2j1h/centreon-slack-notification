# centreon-slack-notification

Based on https://github.com/Shini31/centreon-notifications

## Setup
1. Set up an incoming webhook integration in your Slack team : [Slack incoming webhook integration](https://api.slack.com/incoming-webhooks)
2. Download the scripts in the plugins directory
3. Take config.ini.example as a template, create a file config.ini in same directory and correct configuration according to your preferences:
    * centreon_url : URL of the Centreon Web UI ( eg. https://centreon.foo.bar:8081 )
    * slack_posturl : URL of incoming webhook ( eg. https://hooks.slack.com/services/T00000000/B00000000/XXXXXXXXXXXXXXXXXXXXXXXX )
    * slack_username : Integration's username (eg. Centreon)
4. Don't miss install the following Perl modules : HTTP::Request::Common, LWP::UserAgent, JSON, Getopt::Long, Config::General.
5. Create two new notification's command, host-notify-by-slack and service-notify-by-slack :
    * `perl /directoryofplugins/centreon-slack-notification/host-slack-notification.pl --host="$HOSTNAME$" --state="$HOSTSTATE$" --address="$HOSTADDRESS$" --channel="channelofyourchoice"` --message="$HOSTOUTPUT$"`
    * `perl /directoryofplugins/centreon-slack-notification/service-slack-notification.pl --host="$HOSTNAME$" --address="$HOSTADDRESS$" --output="$SERVICEOUTPUT$" --service="$SERVICEDESC$" --state="$SERVICESTATE$" --channel="channelofyourchoice"`
6. Adapt your notification's configuration for using theses new commands
7. Generate, move and export the new configuration on your all pollers