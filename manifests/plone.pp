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
  package { "git":
    ensure => present,
  }
  package { "libz-dev":
    ensure => present,
  }
  package { "libssl-dev":
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
