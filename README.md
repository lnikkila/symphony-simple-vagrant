Vagrant for Symphony CMS
========================

> Dead-simple development environment intended for Symphony. No mess, no fuss.

What’s Vagrant? See [vagrantup.com][1].

Quick start
-----------

**Put Symphony into `public_html`.** Then do `vagrant up`.

You can delete the `index.php` that outputs information about the PHP
installation.

Apache is available at [localhost:8080][2] and MariaDB at localhost:3636.

A default database called `vagrant` is created automatically. The MariaDB root
password is just `root`.

What’s in the bag
-----------------

> DEAD DOVE, do not eat!

- **Ubuntu 14.04 LTS**

  Specifically the official `ubuntu/trusty32` box. Go ahead and use the 64-bit
  version if possible.

- **Apache 2**

- **MariaDB 5.5**

  The open-source MySQL drop-in replacement.

- **PHP 5.5**

  Comes with the extensions that Symphony depends on, such as `php5-xsl`.

- **Xdebug**

- **Git**


[1]: https://vagrantup.com
[2]: http://localhost:8080
