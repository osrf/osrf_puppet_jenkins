class services  {

  service { "lightdm":
       enable => true,
       ensure => running,
       hasrestart => true,
  }

  case $operatingsystemrelease {
    /!12.04/ : {
      service { "docker.io":
       enable => true,
       ensure => running,
       hasrestart => true,
      }
    }
  }

  service { "jenkins-slave":
       enable => true,
       ensure => running,
       hasrestart => true,
  }
}
