# largely lifted with thanks from:
# https://github.com/rails/rails-dev-box/blob/master/puppet/manifests/default.pp
# note we have to run some commands explicitly as vagrant to make sure certain
# binaries are installed locally
class rails {

    $as_vagrant = 'sudo -u vagrant -H bash -l -c'
    $home       = '/home/vagrant'

    Exec {
        path => ['/usr/sbin', '/usr/bin', '/sbin', '/bin']
    }

    package { "curl":
        ensure => installed,
    }

    exec { 'install_rvm':
        command => "${as_vagrant} 'curl -L https://get.rvm.io | bash -s stable'",
        creates => "${home}/.rvm/bin/rvm",
        require => Package['curl'],
    }

    exec { 'install_ruby':
        command => "${as_vagrant} '${home}/.rvm/bin/rvm install 2.0.0 --latest-binary --autolibs=enabled && rvm --fuzzy alias create default 2.0.0'",
        creates => "${home}/.rvm/bin/ruby",
        require => Exec['install_rvm'],
    }

    exec { "${as_vagrant} 'gem install bundler --no-rdoc --no-ri'":
        creates => "${home}/.rvm/bin/bundle",
        require => Exec['install_ruby'],
    }

    exec { "install_rails":
        command => "${as_vagrant} 'gem install rails --version=4.0.0 --no-rdoc --no-ri'",
        # not ideal at all but will do for now
        creates => "${home}/.rvm/gems/ruby-2.0.0-p247/bin/rails",
        require => Exec['install_ruby'],
    }

    exec { "${as_vagrant} 'rails server -d'":
        cwd     => "/vagrant/src/ruby",
        creates => "/vagrant/src/ruby/tmp/pids/server.pid",
    }

}
