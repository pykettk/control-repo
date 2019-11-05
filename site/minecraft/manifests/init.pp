class minecraft (
  $url = 'https://s3.amazonaws.com/Minecraft.Download/versions/1.12.2/minecraft_server.1.12.2.jar',
  $installDir = '/opt/minecraft'
) {
  file { $installDir:
    ensure => directory,
  }
  file { "${$installDir}/minecraft_server.jar":
    ensure => file,
    source => $url,
    before => Service['minecraft'],
  }
  package { 'java':
    ensure => present,
  }
  file { "${$installDir}/eula.txt":
    ensure => file,
    content => 'eula=true',
  }
  file { '/etc/systemd/system/minecraft.service':
    ensure => file,
    content => epp('minecraft/minecraft.service', {
      $installDir => $installDir,
    }),
  }
  service { 'minecraft':
    ensure => running,
    enable => true,
    require => [
      Package['java'],
      File["${$installDir}/eula.txt"],
      File['/etc/systemd/system/minecraft.service'],
    ],
  }
}
