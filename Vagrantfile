# -*- mode: ruby -*-
# vi: set ft=ruby :

VAGRANTFILE_API_VERSION = '2'

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  config.vm.box = 'ubuntu/trusty32'

  config.vm.network 'forwarded_port', guest: 80, host: 8080
  config.vm.network 'forwarded_port', guest: 3306, host: 3636

  config.vm.synced_folder './public_html', '/var/www/html', \
    owner: 'www-data', \
    group: 'www-data', \
    mount_options: ['dmode=755', 'fmode=644']

  config.vm.provision 'shell', path: './provisioning/provisioning.sh'

  config.ssh.shell = "bash -c 'BASH_ENV=/etc/profile exec bash'"
end
