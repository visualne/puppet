# == Class: pix
#
#I ran this script on a cent7 OS and it worked fine
#Fill in appropriate variables at the top.
#Make sure your ISO is unpacked or mounted to /var/ftp/pub

class pix {

    #Variables
    $subnet = "192.168.5.0"
    $subnet_netmask= "255.255.255.0"
    $range_start = "192.168.5.30"
    $range_end = "192.168.5.50"
    $dns_server = "192.168.5.1"
    $gateway = "192.168.5.1"
    $default_lease_time = "600"
    $max_lease_time = "7200"
    $dhcp_server_ip = "192.168.5.115"
    $ftp_server_ip = "192.168.5.115"
    $kickstartPassword = "TonyPerkins123"


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

    #Making tftpboot directory
    file { "tftpboot":
        path    => "/tftpboot",
        ensure => "directory",
        owner   => 'root',
        group   => 'root',
        mode    => '0777',
        require => File['tftp'],
    }

    #copying needed files to tftpboot directory
    exec {"copyFiles":
        require => File['tftpboot'],
        command => "/usr/bin/cp -v /usr/share/syslinux/pxelinux.0 /tftpboot && /usr/bin/cp -v /usr/share/syslinux/menu.c32 /tftpboot && /usr/bin/cp -v /usr/share/syslinux/memdisk /tftpboot && /usr/bin/cp -v /usr/share/syslinux/mboot.c32 /tftpboot && /usr/bin/cp -v /usr/share/syslinux/chain.c32 /tftpboot",
    }

    #Making needed dirctories for pxe
    file { "pxelinux":
        path    => "/tftpboot/pxelinux.cfg",
        ensure => "directory",
        owner   => 'root',
        group   => 'root',
        mode    => '0777',
        require => Exec['copyFiles'],
    }

    #Making needed dirctories for pxe
    file { "netboot":
        path    => "/tftpboot/netboot/",
        ensure => "directory",
        owner   => 'root',
        group   => 'root',
        mode    => '0777',
        require => File['pxelinux'],
    }

    #########################
    #AT THIS POINT YOU WILL NEED AN OS's ISO contents unpacked somewhere.
    #in my case I unpacked it to /var/ftp/pub/
    #########################

    #COPYING NEEDED FILED FROM UNPACKED ISO TO /tftpboot/netboot/ directory
    exec {"netbootCopy":
        require => File['netboot'],
        command => "/usr/bin/cp -v /var/ftp/pub/images/pxeboot/vmlinuz /tftpboot/netboot/ && /usr/bin/cp -v /var/ftp/pub/images/pxeboot/initrd.img /tftpboot/netboot/ ",
    }

    #Moving kickstart file into place.
    file { "ksFile":
        path    => "/var/ftp/pub/ks.cfg",
        owner   => 'root',
        group   => 'root',
        mode    => '0755',
        require => Exec['netbootCopy'],
        content => template('visualne-pix/ks.erb'),
      }

    #Moving default file into place.
    file { "default":
        path    => "/tftpboot/pxelinux.cfg/default",
        owner   => 'root',
        group   => 'root',
        mode    => '0755',
        require => File['ksFile'],
        content => template('visualne-pix/default.erb'),
      }


    #Mkaing sure services are running and chkconfig'd
    service { ['dhcpd', 'xinetd', 'vsftpd']:
      require => File['default'],
      enable => true,
      ensure => running,
    }
}

include pix
