$confdir_setting = $settings::confdir
class files {

  file_line { "/etc/sudoers":
    ensure => present,
    line   => 'jenkins ALL=(ALL) NOPASSWD:ALL',
    path   => '/etc/sudoers',
  }

  # jenkins-slave script seems not be work from the init/rc.2 system
  # workaround by using rc.local
  file_line { "/etc/rc.local":
    ensure => present,
    line   => 'service jenkins-slave restart',
    path   => '/etc/rc.local',
  }

  file { "/etc/lightdm/xhost.sh":
        source => "$confdir_setting/files/etc/lightdm/xhost.sh",
        mode=> "0744",
        require => Package[lightdm],
	notify => Exec[service_lightdm_restart],
  }

  # This two rules do: check if no lightdm is present and create one
  # Ensure that display-setup-script is set

  file { "/etc/lightdm/lightdm.conf":
    source => "$confdir_setting/files/etc/lightdm/lightdm.conf",
    replace => "no", # this is the important property
    ensure  => "present",
  }

  file_line { "/etc/lightdm/lightdm.conf":
    require => File['/etc/lightdm/lightdm.conf'],
    ensure => present,
    line   => 'display-setup-script=/etc/lightdm/xhost.sh',
    path   => '/etc/lightdm/lightdm.conf',
  }

  file { "/etc/squid-deb-proxy":
        source  => "$confdir_setting/files/etc/squid-deb-proxy",
        require => Package[squid-deb-proxy],
        recurse => true,
  }

  exec { 'service_lightdm_restart':
    refreshonly => true,
    command     => "/usr/sbin/service lightdm restart",
    require     => Package[lightdm],
  }
}
