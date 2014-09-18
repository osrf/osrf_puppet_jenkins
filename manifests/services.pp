class slave_services  {

  service { "lightdm":
       enable => true,
       ensure => running,
       hasrestart => true,
  }

  service { "docker.io":
       enable => true,
       ensure => running,
       hasrestart => true,
  }

  service { "jenkins-slave":
       enable => true,
       ensure => running,
       hasrestart => true,
  }
}
