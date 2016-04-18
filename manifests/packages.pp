class packages {

 package { "wget"            : ensure => installed }
 package { "mercurial"       : ensure => installed }
 package { "groovy"          : ensure => installed }
 package { "ntp"             : ensure => installed }
 package { "lightdm"         : ensure => installed }
 package { "squid-deb-proxy" : ensure => installed }
 package { "default-jre-headless" : ensure => installed }
 # Enable proper HTTTPS support for bitbucket python client
 package { "libffi-dev"      : ensure => installed }
 package { "libssl-dev"      : ensure => installed }

 # Docker support. Ubuntu packages are outdated, using docker ones
 case $operatingsystemrelease {
   12.04 : {
       exec {'no-docker-script':
           command => "echo 'No docker on Precise'"
       }
   }
   default : {
       exec {'docker-script':
           command => "/usr/bin/curl -sSL https://get.docker.com | sudo sh",
           require => Package['wget']
        }

       package { "qemu-user-static"  : ensure => installed }
   }
 }

 define url-package (
  $url,
  $provider,
  $package = undef) 
 {

  if $package {
    $package_real = $package
  } else {
    $package_real = $title
  }

  $package_path = "/tmp/${package_real}"

  exec {'download':
    command => "/usr/bin/wget -O ${package_path} ${url}"
  }

  package {'install':
    ensure   => installed,
    name     => "${package}",
    provider => 'dpkg',
    source   => "${package_path}",
  }

  file {'cleanup':
    ensure => absent,
    path   => "${package_path}",
  }

  Exec['download'] -> Package['install'] -> File['cleanup']

 }

 case $operatingsystemrelease {
   12.04 : {
     package { "jenkins-slave" : ensure => installed }
   }

   # slave was removed from newer ubuntu versions. TODO: update this procedure
   default : {
      url-package { "jenkins-slave" :
         provider  => dpkg,
         url       => 'http://packages.osrfoundation.org/gazebo/ubuntu/pool/main/j/jenkins/jenkins-slave_1.509.2+dfsg-2_all.deb',
      }
   }
 }
}
