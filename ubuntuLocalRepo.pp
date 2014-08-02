##########
#Check out my blog at: http://visualne.wordpress.com/2014/07/25/create-ubuntu-repository/ for the steps to do this by hand
##########

#Installing apache
package { "apache2":
    ensure => "installed"
}

#Installing dpkg-scanpackages which houses the command
#dpkg-scanpackages which creates gz file that apt-get update will
#read. PUT ANY PACKAGE you NEED IN THE /var/www/debs/x86_64 directory
#and then run the dpkg-scanpackages . /dev/null | gzip -9c > /var/www/debs/x86_64/Packages.gz command
package { "dpkg-dev":
	ensure => "installed"
}

#Array variable to hold each directory that needs to created.
$repo_dir = [ "/var/www/debs","/var/www/debs/x86_64"]

#Variable that holds the sed command to be used to add repo to sources.list
$cmd = "sed -i '1i #Local Repo' /etc/apt/sources.list | sed -i '1i deb http://127.0.0.1/debs/ x86_64/' /etc/apt/sources.list"


#Create directory structure
file { $repo_dir:
    require => Package['apache2'],
    ensure => "directory",
    owner  => "root",
    group  => "root",
    mode   => 755,
}

#Adding repo to /etc/apt/sources.list
exec { "add-repo":
    require => File[$repo_dir],
    command => "${cmd}",
    path    => "/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games",
}
