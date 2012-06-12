#!/bin/bash
#
# Can also be started by ../script/basebox-creation
#
# Script for creation of the basebox with veewee.
# * creation of the basebox
# * creation of a servtag-postinstall.sh script that will be copied to definitions/your-basebox/servtag-postinstall.sh and that should be run by veewee
# 
#
# src: http://www.dejonghenico.be/unix/create-vagrant-base-boxes-veewee
#

#######################################################
# Script variables
#
#######################################################

# The template that will be use to create the basebox
vagrant_template="ubuntu-11.10-server-amd64"
# The name of the basebox
baseboxname="servtag-test8"

system_password="vagrant1" #TODO ändern für vagrant
mysql_password="vagrant1" #TODO ändern für vagrant


#######################################################
# Helpers
#
#######################################################
#
# Format the ouput to inform the user of his configuration
function helper_writeinformation () {
	if [ $last_return_status == 0 ]; then
		status="OK"
	else
		status="failed"
	fi
	echo $last_message_status."..............................[".$status."]"
}

#######################################################
# Verification of the system
#	./configure -like
#######################################################
function configuration_checker() {
	# check 1: are we in the good directory?
	# use pwd? ls?
	last_return_status=1
	last_message_status="CONFIGURATION .... pending(not implemented)"
	helper_writeinformation
	
	# check 2: do we have ./veewee created?
	# ls... easy

	# check 3: do we have every software we need?
	# Which?

	# check4: would it be possible to check if the bios is correctly configured?

	# check5: do we have a iso directory

	 # Do we have an iso in baseboxes/iso ?
}

#######################################################
# Creation of the basebox
#
# * Create a basebox
# * Inject the ./.servtag-postpostinstall.sh script at the end of ./definition/$baseboxname/postinstallation.sh
#######################################################
function  basebox_creation_runner() {
	# Creating the configuration files of the box
	vagrant basebox define $baseboxname $vagrant_template

	# Adapting the layout
#	sed -i -e 's/USA/Germany/g' definitions/$baseboxname/preseed.cfg #NEW
	#sed -i -e 's/en_US/de_DE/g' definitions/$baseboxname/definition.rb
	#sed -i -e 's/USA/Deutschland/g' definitions/$baseboxname/definition.rb
	#sed -i -e 's/=US/=DE/g' definitions/$baseboxname/definition.rb
	sed -i -e 's/en_US/de_DE/g' definitions/$baseboxname/preseed.cfg
#	sed -i -e 's/layout string USA/layoutcode=de/g' definitions/$baseboxname/preseed.cfg #NEW
	sed -i -e 's/method=us/method=de/g' definitions/$baseboxname/definition.rb
	sed -i -e 's/layout=USA/layout=de/g' definitions/$baseboxname/definition.rb
	sed -i -e 's/variant=USA/variant=DE/g' definitions/$baseboxname/definition.rb

	# Changing the hostname
	sed -i -e "s/get_hostname string unassigned-hostname/get_hostname string $baseboxname/g" definitions/$baseboxname/definition.rb


	# Moving our postinstall file and saying vagrant it has to be launched
	cp .servtag-postpostinstall.sh definitions/$baseboxname/servtag-postinstall.sh
	sed -i -e 's/"],/", "servtag-postinstall.sh"], /g' definitions/$baseboxname/definition.rb


	# Changing the password
	sed -i -e "s/user-password password vagrant/user-password password $system_password/g" definitions/$baseboxname/preseed.cfg
	sed -i -e "s/user-password-again password vagrant/user-password-again password $system_password/g" definitions/$baseboxname/preseed.cfg
	sed -i -e "s/root_password password vagrant/root_password password $mysql_password/g" definitions/$baseboxname/servtag-postinstall.rb
	sed -i -e "s/root_password_again password vagrant/root_password_again password $mysql_password/g" definitions/$baseboxname/servtag-postinstall.rb
	sed -i -e "s/:ssh_password => \"vagrant\"/ :ssh_password => \"$system_password\"/g" definitions/$baseboxname/definition.rb

	# Just do it!
	vagrant basebox build $baseboxname
}

#######################################################
# run
#
#######################################################

echo ""
echo "CONFIGURATION"
echo "============="
configuration_checker

echo ""
echo ""
echo "CREATION OF THE BASEBOX"
echo "======================="
basebox_creation_runner

exit 0
