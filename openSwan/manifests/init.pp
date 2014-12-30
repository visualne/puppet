class openSwan {

    #Notes
    #Make sure it installs openswan 2.6.32 instead of 2.6.37
    #This works between a cisco asa 5510 and a amazon Rhel6.5 free tier micro instance.
    #

    #############Variables##############

    ###################################	
    #The below variables hold the specifics of the tunnel and are
    #used to populate the /etc/ipsec.d/vpc-to-asa.conf file and the
    #/etc/ipsec.d/vpc-to-asa.secrets file

    $left= "%defaultroute"
    $elastic_ip = "ELASTIC_IP_OF_INSTANCE"
    $leftnexthop="%defaultroute"
    $leftsubnet="SUBNET_THE_VM_IS_IN"
    $public_ip_of_asa="PUBLIC_IP_OF_ASA"
    $rightsubnet="SUBNET_BEHIND_ASA"
    $esp="PHASE-2-CONFIGURATION ex)aes256-sha1;modp1024"
    $keyexchange="KEY_EXCHANGE_METHOD ex)ike"
    $ike="PHASE-1-CONFIGURATION ex)aes256-sha1;modp1536"
    $salifetime="SA-LIFETIME ex)28800s"
    $pfs="PFS ex)yes"
    $auto="THIS VARIABLE CONTROLLS HOW THE TUNNEL is BROUGHT up 'start' bring its up without interesting traffic ex)start"
    $dpdaction="GOING TO HAVE TO LOOK THIS ONE UP ex)restart"
    $psk="PRE-SHARED_KEY to use ex)asdj$d34dfjhba!2asjkdfabj"
    ####################################

    #Command for finding and replacing line to turn routing on in 
    $cmd = "sed -i 's/net.ipv4.ip_forward = 0/net.ipv4.ip_forward = 1/g' /etc/sysctl.conf"
    ####################################


    #Turning on ip forwarding
    exec { "ip-forwarding-enable":
        command => "${cmd}",
        path => "/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games",
    }

    #Installing openswan
    #Make sure this is openswan 2.6.32 - I had issues with 2.6.37
    package { "openswan":
        ensure => "installed"
    }

    #Command that uncomments out the line in the ipsec.conf file.
    file { "/etc/ipsec.conf":
        require => Package['openswan'],
        mode   => 600,
        owner  => root,
        group  => root,
        content => template("openSwan/ipsec.conf.erb"),
    }

    #Creating the vpc-to-asa.conf file that will hold specific config
    #related to the tunnel.
    file { 'vpc-to-asa.conf':
        path    => '/etc/ipsec.d/vpc-to-asa.conf',
        ensure  => file,
        require => Package['openswan'],
        content => template("openSwan/vpc-to-asa.conf.erb"),
    }

    #Creating vpc-to-asa.secrets file that will house the pre-shared key 
    #and endpoints of the tunnel.
    file { 'vpc-to-asa.secrets':
        path    => '/etc/ipsec.d/vpc-to-asa.secrets',
        ensure  => file,
        require => Package['openswan'],
        content => template("openSwan/vpc-to-asa.secrets.erb"),
    }

    #Starting and chkconfig'ing the ipsec service
    service { "ipsec":
        require => [ File['vpc-to-asa.conf'], File['vpc-to-asa.secrets'] ],
        ensure => "running",
        enable => true,
    }

}

include openSwan
