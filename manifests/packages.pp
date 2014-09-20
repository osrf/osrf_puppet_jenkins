class packages {

 package { "wget"            : ensure => installed }
 package { "jenkins-slave"   : ensure => installed }
 package { "mercurial"       : ensure => installed }
 package { "ntp"             : ensure => installed }
 package { "lightdm"         : ensure => installed }
 package { "docker.io"       : ensure => installed }
 package { "squid-deb-proxy" : ensure => installed }

}
