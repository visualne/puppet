###########Need code to add the epel repository############


#########Need some code here to change the hostname of this box.########


########Installing all packages needed##########

#Installing cobbler,dnsmasq,dhcp,tftp
package { ["cobbler","dnsmasq","dhcp","tftp"]:
    ensure => "installed"
}


########chkconfig'ing all services###########

#Cobbler service
service { "cobblerd":
  enable => true,
  require => Package['cobbler']
}

#http service
service { ["httpd","dnsmasq","dhcpd","tftp"]:
  enable => true,
  require => Package['cobbler']
}


###################Changing all config files for services#############
file { "/etc/cobbler/modules.conf":
  ensure  => file,
  content => template('/root/puppet/cobbler/templates/modules.erb'),
}
