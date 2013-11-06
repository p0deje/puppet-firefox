# == Class: firefox
#
# Simple module installing Firefox from packaged DEBs.
#
# === Parameters
#
# [*version*]
#   Firefox version. Defaults to latest.
#
# === Examples
#
# class { 'firefox':
#   version => '24.0-0ubuntu1'
# }
#
# === Authors
#
# Alex Rodionov <p0deje@gmail.com>
#
# === Copyright
#
# Copyright 2013 Alex Rodionov
#
class firefox(
  $version = latest,
) {

  # Ubuntuzilla ships with latest version, so we can use its APT repo to install it.
  #
  # However, if we need specific version, we have to manually download and install
  # DEB from repository. List of all versions is available at
  # http://sourceforge.net/projects/ubuntuzilla/files/mozilla/apt/pool/main/f/firefox-mozilla-build.

  case $version {
    /[0-9\.-]+ubuntu[0-9]+/: {
      $url = 'http://sourceforge.net/projects/ubuntuzilla/files/mozilla/apt/pool/main/f/firefox-mozilla-build'
      $deb = "firefox-mozilla-build_${version}_${$::architecture}.deb"

      exec { 'download':
        command => "wget ${url}/${deb}/download -O /tmp/$deb",
        creates => "/tmp/${deb}",
        unless  => "dpkg -l | grep firefox-mozilla-build | grep ${version}",
        path    => ['/bin' ,'/usr/bin'],
      }

      package { 'firefox-mozilla-build':
        provider => dpkg,
        ensure   => latest,
        source   => "/tmp/${deb}",
        require  => Exec['download'],
      }

      # TODO need to remove DEB file after installation
      # but it breaks "latest" dpkg package
    }

    default: {
      apt::source { 'ubuntuzilla':
        location    => 'http://downloads.sourceforge.net/project/ubuntuzilla/mozilla/apt',
        release     => 'all',
        repos       => 'main',
        key         => 'C1289A29',
        key_server  => 'keyserver.ubuntu.com',
        include_src => false,
      }

      package { 'firefox-mozilla-build':
        ensure  => $version,
        require => Apt::Source['ubuntuzilla'],
      }
    }
  }

  package { 'xul-ext-ubufox':
    ensure  => present,
    require => Package['firefox-mozilla-build'],
  }
}
