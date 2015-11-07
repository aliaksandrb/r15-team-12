# -*- mode: ruby -*-
# vi: set ft=ruby :

unless Vagrant.has_plugin?('vagrant-vbguest')
  raise 'Please install the vagrant-vbguest plugin by running `vagrant plugin install vagrant-vbguest`'
end

VAGRANTFILE_API_VERSION = 2
RUBY_VER = '2.2.3'
MEMORY = 8192
CPU_COUNT = 4

# POSTGRES
PG_VERSION = 9.3
PG_CONF = "/etc/postgresql/#{PG_VERSION}/main/postgresql.conf"
PG_HBA = "/etc/postgresql/#{PG_VERSION}/main/pg_hba.conf"
PG_DIR = "/var/lib/postgresql/#{PG_VERSION}/main"
APP_DB_USER = 'fighter'
APP_DB_PASS = 'password'
APP_DB_NAME = APP_DB_USER

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  config.vm.box = 'ubuntu/trusty64'

  # config.vm.box_check_update = false

  config.vm.network :forwarded_port, guest: 3000, host: 3000
  config.vm.network :private_network, ip: '192.168.33.10'
  config.vm.synced_folder '.', '/vagrant', nfs: true

  config.vm.provider :virtualbox do |vb|
    vb.name = 'rails_rumble'
    vb.memory = MEMORY
    vb.cpus = CPU_COUNT
    vb.customize ['modifyvm', :id, '--cpuexecutioncap', '50']
  end

  config.vm.provision 'Update the packaqes list', type: 'shell' do |s|
    s.inline = 'sudo apt-get update > /dev/null 2>&1'
    s.inline = 'sudo apt-get -y upgrade > /dev/null 2>&1'
  end

  config.vm.provision "Install RVM and Ruby #{RUBY_VER} and Bundler",
    type: 'shell', privileged: false, inline: <<-SHELL
      gpg --keyserver hkp://keys.gnupg.net --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3 > /dev/null 2>&1
      curl -sSL https://get.rvm.io | bash -s stable > /dev/null 2>&1
      source $HOME/.rvm/scripts/rvm

      rvm use --default --install #{RUBY_VER} > /dev/null 2>&1
      rvm cleanup all

      echo 'gem: --no-rdoc --no-ri' >> ~/.gemrc
  SHELL

  config.vm.provision 'Install and configure Postgres', type: 'shell', inline: <<-SHELL
    sudo /usr/sbin/update-locale LANG=en_US.UTF-8 LC_ALL=en_US.UTF-8
    sudo apt-get update > /dev/null 2>&1
    sudo apt-get install -y postgresql-#{PG_VERSION} libpq-dev postgresql-contrib-#{PG_VERSION}

    sudo sed -i "s/#listen_addresses = 'localhost'/listen_addresses = '*'/" "#{PG_CONF}"
    sudo echo 'host    all             all             all                     md5' | sudo tee --append #{PG_HBA}

    sudo echo "client_encoding = utf8" | sudo tee --append #{PG_CONF}
    sudo service postgresql restart
  SHELL


  config.vm.provision 'Install other project dependencies..', type: 'shell' do |s|
    s.inline = 'sudo apt-get install -y git make libssl-dev g++ nodejs libgmp-dev > /dev/null 2>&1'
  end

  config.vm.provision 'Create a new Rails application', type: 'shell', inline: <<-SHELL
    cd /vagrant

    rvm use #{RUBY_VER}
    gem install bundler
    gem install rails

    rails new .
    bundle install
  SHELL

  config.vm.provision 'PROVISIONING COMPLETE!', run: 'always', type: 'shell',
    privileged: false, inline: <<-SHELL
      echo -e '\nTo run the server:\n'
      echo -e '\n vagrant ssh\n'
      echo -e '\n cd /vagrant\n'
      echo -e '\n BOOST=1 bundle exec rails s\'
  SHELL

  config.vbguest.auto_reboot = true
  config.vbguest.auto_update = true
end

