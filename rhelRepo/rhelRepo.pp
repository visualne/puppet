#Installing apache
package { "httpd":
    ensure => "installed"
}

#Installing create-repo which houses the command
#create-repo which creates gz file that yum install will
#read. PUT ANY PACKAGE you NEED IN THE /var/www/html/rpms directory
#and then run the createrepo . (In the /var/www/html/rpms directory)
package { "createrepo":
	ensure => "installed"
}

#Array variable to hold each directory that needs to created.
$repo_dir = [ "/var/www/html","/var/www/html/rpms"]

#Variable that holds the sed command to be used to add repo to sources.list
#$cmd = "sed -i '1i #Local Repo' /etc/apt/sources.list | sed -i '1i deb http://127.0.0.1/debs/ x86_64/' /etc/apt/sources.list"


#Create directory structure
file { $repo_dir:
    require => Package['httpd'],
    ensure => "directory",
    owner  => "root",
    group  => "root",
    mode   => 755,
}

#Adding repo to /etc/apt/sources.list
#exec { "add-repo":
#    require => File[$repo_dir],
#    command => "${cmd}",
#    path    => "/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games",
#}
