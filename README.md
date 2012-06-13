vagrant_tests
=============

* Creating a basebox
====================
cd ~/baseboxes
./create-basebox.sh
vagrant basebox export $baseboxname
vagrant box add base_box_name ./base_box_name.box 

Using Vagrant and veewee this will configure and create you the basebox you need to start the tests.

System and mysql passwords can be changed and are located at the begining of create-basebox.sh
