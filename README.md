## puppet-firefox

Simple Puppet module to install Firefox packaged DEBs from [Ubuntuzilla](http://sourceforge.net/projects/ubuntuzilla/).

### Examples

    class { 'firefox':
      version => '24.0-0ubuntu1'
    }

### Notes

Ubuntuzilla ships with latest version, so we can use its APT repo to install it.

However, if we need specific version, we have to manually download and install DEB from repository.
List of all versions is available at [Sourceforge](http://sourceforge.net/projects/ubuntuzilla/files/mozilla/apt/pool/main/f/firefox-mozilla-build).

### Support

Tested to work on Ubuntu 10.04, 12.04.
