package { "apache2":
    ensure => "installed"
}

#Array variable to hold each directory that needs to created.
$repo_dir = [ "/var/www/debs","/var/www/debs/x86_64"]

#Variable that holds the sed command to be used to add repo to sources.list
$cmd = "sed -i '1i #Local Repo' /etc/apt/sources.list | sed -i '1i deb http://127.0.0.1/debs/x86_64' /etc/apt/sources.list"


#Create directory
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
