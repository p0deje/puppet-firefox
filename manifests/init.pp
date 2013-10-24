# == Class: firefox
#
# Simple module installing Firefox from Apt repository.
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
  apt::source { 'ubuntumozilla':
    location   => 'http://downloads.sourceforge.net/project/ubuntuzilla/mozilla/apt/',
    release    => 'all',
    repos      => 'main',
    key        => 'C1289A29',
    key_server => 'keyserver.ubuntu.com',
  }

  package { 'firefox-mozilla-build':
    ensure  => $version,
    require => Apt::Source['ubuntumozilla'],
  }

  package { 'xul-ext-ubufox':
    ensure  => present,
    require => Package['firefox-mozilla-build'],
  }
}
