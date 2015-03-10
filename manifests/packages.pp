class packages {

 package { "wget"            : ensure => installed }
 package { "mercurial"       : ensure => installed }
 package { "ntp"             : ensure => installed }
 package { "lightdm"         : ensure => installed }
 package { "squid-deb-proxy" : ensure => installed }
 package { "default-jre-headless" : ensure => installed }

 # Docker support
 case $operatingsystemrelease {
   12.04 : {
        package { "curl" : ensure => installed }
	exec {'docker-script':
           command => "/usr/bin/curl -sSL https://get.docker.io/ubuntu/ | sudo sh",
           require => Package['curl']
        }
   }
   default : {
       package { "docker.io"         : ensure => installed }
       package { "qemu-user-static " : ensure => installed }
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
         url       => 'http://mirrors.kernel.org/ubuntu/pool/universe/j/jenkins/jenkins-slave_1.509.2+dfsg-2_all.deb',
      }
   }
 }
}
