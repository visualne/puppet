###########Need code to add the epel repository############


#########Need some code here to change the hostname of this box.########


########Installing all packages needed##########

package { ["cobbler","dnsmasq","dhcp","tftp"]:
    ensure => "installed"
}


########chkconfig'ing all services###########

service { ["cobblerd","httpd","dnsmasq","dhcpd","tftp"]:
  enable => true,
  require => Package['cobbler']
}


###################Changing all config files for services#############

file { "/etc/cobbler/modules.conf":
  ensure  => file,
  content => template('/root/puppet/cobbler/templates/modules.erb'),
  require => Package['cobbler']
}
