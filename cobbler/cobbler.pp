#########Need code to add the epel repository############


#########Need some code here to change the hostname of this box.########


########Installing all packages needed##########

#Installing cobbler
package { "cobbler":
    ensure => "installed"
}

#Installing dnsmasq
package { "dnsmasq":
    ensure => "installed"
}

#Installing dhcp
package { "dhcp":
    ensure => "installed"
}

#Installing tftp
package { "tftp":
    ensure => "installed"
}


########chkconfig'ing all services###########

#Cobbler service
service { "cobblerd":
  enable => true,
  require => Package['cobbler']
}

#http service
service { "httpd":
  enable => true,
  require => Package['cobbler']
}

#dnsmasq service
service { "dnsmasq":
  enable => true,
  require => Package['cobbler']
}

#dhcp service
service { "dhcpd":
  enable => true,
  require => Package['cobbler']
}

#tftp service
service { "tftp":
  enable => true,
  require => Package['cobbler']
}


###################Changing all config files for services#############
file { "/etc/cobbler/modules.conf":
  ensure  => file,
  content => template('/root/Puppet/cobbler/templates/modules.erb'),
}
