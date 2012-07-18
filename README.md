vagrant_tests
=============

* Creating a basebox
====================

check your configuration:
cd ~/baseboxes && ./create-basebox.sh -c

create a basebox
cd ~/baseboxes && ./create-basebox.sh -c

Using Vagrant and veewee this will configure and create you the basebox you need to start the tests.

System and mysql passwords can be changed and are located at the begining of create-basebox.sh

The name of your basebox is also at the begining of create-basebox.sh

Once your box have been with success created, you can modifiy /conf/application.yml to use it!


* Starting the test
===================
Most of the possibles tests are always define in ./test/
Just run one of them:
RAILS_ENV=vagrant ruby tests/integration-frontend.rb


* Furhter Documentation:
=======================
* Vagrant: https://github.com/jedi4ever/veewee/blob/master/doc/vagrant.md
* Veewee: https://github.com/jedi4ever/veewee/
* VirtualBox: https://github.com/jedi4ever/veewee/blob/master/doc/vbox.md

