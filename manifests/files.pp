class files {

 file { "/etc/sudoers":
    source => "puppet://files/etc/sudoers",
    mode=> "440",
    owner => "root",
    group => "root",
  }

  file { "/etc/lightdm/xhost.sh":
        source => "puppet://files/etc/lightdm/xhost.sh",
        require => Package[lightdm],
	notify => Exec[service_lightdm_restart],
  }

  file { "/etc/squid-deb-proxy":
        source  => "puppet://files/etc/squid-deb-proxy",
        require => Package[squid-deb-proxy],
        recurse => true,
  }

  exec { 'service_lightdm_restart':
    refreshonly => true,
    command     => "/usr/sbin/service lightdm restart",
    require     => Package[lightdm],
  }
}
