# == Class: pix
#
# Full description of class pix here.
#
# === Parameters
#
# Document parameters here.
#
# [*sample_parameter*]
#   Explanation of what this parameter affects and what it defaults to.
#   e.g. "Specify one or more upstream ntp servers as an array."
#
# === Variables
#
# Here you should define a list of variables that this module would require.
#
# [*sample_variable*]
#   Explanation of how this variable affects the funtion of this class and if
#   it has a default. e.g. "The parameter enc_ntp_servers must be set by the
#   External Node Classifier as a comma separated list of hostnames." (Note,
#   global variables should be avoided in favor of class parameters as
#   of Puppet 2.6.)
#
# === Examples
#

class pix {

    #Variables
    $subnet = "192.168.9.0"
    $subnet_netmask= "255.255.255.0"
    $range_start = "192.168.1.30"
    $range_end = "192.168.1.50"
    $dns_server = "192.168.1.1"
    $gateway = "192.168.1.1"
    $default_lease_time = "600"
    $max_lease_time = "7200"
    $dhcp_server_ip = "192.168.1.115"


    #Installing required packages
    package { ['dhcp', 'tftp', 'tftp-server', 'syslinux', 'wget', 'vsftpd']:
        ensure => installed
    }

    #Changing configuration associated with dhcp server
    file { "dhcpd.conf":
        path    => "/etc/dhcp/dhcpd.conf",
        owner   => 'root',
        group   => 'root',
        mode    => '0644',
        require => Package['dhcp', 'tftp', 'tftp-server', 'syslinux', 'wget', 'vsftpd'],
        content => template('visualne-pix/dhcpd.erb'),
      }

    #Changing configuration associated with xinetd/tftp server
    file { "tftp":
        path    => "/etc/xinetd.d/tftp",
        owner   => 'root',
        group   => 'root',
        mode    => '0644',
        require => File['dhcpd.conf'],
        content => template('visualne-pix/tftp.erb'),
      }

}

include pix
