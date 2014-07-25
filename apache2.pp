package { "apache2":
    ensure => "installed"
}

#Array variable to hold each directory that needs to created.
$repo_dir = [ "/var/www/debs","/var/www/debs/x86_64"]

#Create directory
file { $repo_dir:
    require => Package['apache2'],
    ensure => "directory",
    owner  => "root",
    group  => "root",
    mode   => 755,
}
                 
