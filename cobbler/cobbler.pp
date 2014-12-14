###########Need code to add the epel repository############


#########Need some code here to change the hostname of this box.########


########Installing all packages needed##########

package { ["cobbler","dnsmasq","dhcp","tftp","xinetd"]:
    ensure => "installed"
}

########chkconfig'ing all services###########
service { ["cobblerd","httpd","dnsmasq","dhcpd","tftp","xinetd"]:
  enable => true,
  ensure => running,
  require => Package['cobbler']
}

###################Changing all config files for services#############
file { "/etc/cobbler/modules.conf":
  notify  => Service["cobblerd"],
  ensure  => file,
  content => template('/root/puppet/cobbler/templates/modules.erb'),
  require => Package['cobbler']
}

#Need to add variable for server and next_server variable
file { "/etc/cobbler/settings":
  notify  => Service["cobblerd"],
  ensure  => file,
  content => template('/root/puppet/cobbler/templates/settings.erb'),
  require => Package['cobbler']
}

#Need to add variable for server and next_server variable
file { "/etc/cobbler/dhcp.template":
  notify  => Service["cobblerd"],
  ensure  => file,
  content => template('/root/puppet/cobbler/templates/dhcp.template.erb'),
  require => Package['cobbler']
}

#Needed to run the command below due to syslinux and pxe https://bugzilla.redhat.com/show_bug.cgi?id=581650
exec { "cobbler get-loaders":
    notify  => Service["cobblerd"],
    command => "cobbler get-loaders",
    path    => "/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin:/root/bin",
    # path    => [ "/usr/local/bin/", "/bin/" ],  # alternative syntax
}

#Need to create user and password for web interface
#htdigest /etc/cobbler/users.digest “Cobbler” cobbler


