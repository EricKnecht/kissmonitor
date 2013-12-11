KissMonitor
=====================
KissMonitor is a Simple and Stupid monitoring system written in ruby


Assumptions/dependencies
------------------------
* Ruby version >= 1.8.7 
  - This was chosen because 1.8.7 is still (unfortunatly) the default ruby on many linux distros
* Currently only Linux is tested (both Centos and Ubuntu) but it should work on other unixes
  - Windows support is possible, but would likely require some modifications to the metric collectors
    I don't currently have a windows machine to test on


Configuration File
--------------------
KissMonitor is controlled by a single yaml file
the repository include a commented [sample file](config.sample.yaml)
This file could easily be generated/deployed by a configuration management tool such as Ansible/Puppet/Chef/ect

Extending KissMonitor
---------------------
KissMonitor was designed to be very easy to extend. There are three places where plugins are added
 * Metric Collectors: these are pieces of code that collect new data from the system. 
   - For example: nginx requests per second or number of mysql connections
 * Alerters: These are new ways for the team to be alerted to issues 
   - Support of HipChat, Email, and Pagerduty are included
 * Shippers: These ship the metric data to an external service, such as statsd

Running KissMonitor Manually
----------------------
`kissm monitor --config path/to/config.yaml`

Deploying KissMonitor
---------------------
KissMonitor is intended to be run via cron, this was chosen because it was more straight forward and easier to implement than an agent that runs all the time as a system service. 

I'm working on creating a native package for each deployment target


Testing with Vagrant
--------------------
1. Update the [sample file](config.sample.yaml) to send to a real email 
1. `vagrant up` and two vagrant boxes running kissmonitor with the sample config will be started
1. Lower the disk usage,cpu, or ram threshold for / to something very low (to trigger a test alert)
1. Wait patiently for your email
1. Raise the threshold back to a sane value, the alert close and send an All clear email
