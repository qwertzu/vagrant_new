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
baseboxname="servtag-test7"

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
	# Building the box
	vagrant basebox define $baseboxname $vagrant_template

	#Adapting the preseed.cfg file
	sed -i -e 's/en_US/de_DE/g' definitions/$baseboxname/preseed.cfg #NEW
	sed -i -e 's/USA/Germany/g' definitions/$baseboxname/preseed.cfg #NEW

	# change the username/passwort? in preseed.cfg


	# We add our work at the end of the post-install file
	# cf http://www.commentcamarche.net/forum/affich-1533480-bash-insertion-d-une-ligne-dans-un-fichier
	#cp .servtag-postpostinstall.sh inject-to-postinstall.sh
	#sed -i -e ':a;N;$!ba;s/\n/\\n/g' inject-to-postinstall.sh  #remplacing EOL by \n
	#sed -i -e "s/exit*$/`cat inject-to-postinstall.sh`\nexit/g" definitions/$baseboxname/postinstall.sh

	cp .servtag-postpostinstall.sh definitions/test1/servtag-postinstall.sh
	sed -i -e 's/"],/"], ["servtag-postinstall.sh"]/g' definitions/test1/definition.rb

	rm inject-to-postinstall.sh

	# do it!
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
echo "============="
basebox_creation_runner

exit 0
