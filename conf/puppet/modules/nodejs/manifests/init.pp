class nodejs {

    include "apt"

    apt::ppa { "ppa:chris-lea/node.js": }

    package { "nodejs":
        ensure  => present,
        require => Apt::Ppa["ppa:chris-lea/node.js"],
    }
}
