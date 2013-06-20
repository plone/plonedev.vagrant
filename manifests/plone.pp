class plone {

  package { "build-essential":
    ensure => present,
  }
  package { "python-dev":
    ensure => present,
  }
  package { "libjpeg-dev":
    ensure => present,
  }
  package { "libxml2-dev":
    ensure => present,
  }
  package { "libxslt-dev":
    ensure => present,
  }

  # coredev dependencies
  package { "subversion":
    ensure => present,
  }
  package { "git":
    ensure => present,
  }
  package { "python-pip":
    ensure => present,
  }

  # used for creating a PuTTy-compatible key file
  package { "putty-tools":
    ensure => present,
  }

}

include plone
