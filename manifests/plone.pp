class plone {

  # This apt-get update below is meant to ward
  # off "Unable to fetch some archives, maybe run apt-get update or try with --fix-missing?"
  # errors.
  # exec { 'apt-get update':
  #   command => '/usr/bin/apt-get update',
  #   unless => "/usr/bin/test -d Plone"
  # }

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

  # Optional packages to enable indexing of office/pdf docs
  # package { "wv":
  #   ensure => present,
  # }
  # package { "poppler-utils":
  #   ensure => present,
  # }

  # used for creating a PuTTy-compatible key file
  package { "putty-tools":
    ensure => present,
  }

}

include plone
