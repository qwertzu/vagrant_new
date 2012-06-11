#!/bin/bash
#
# Can also be started by ../script/basebox-creation
#
# Script for creation of the basebox with veewee.
# * creation of the basebox
# * creation of a servtag-postinstall.sh script that will be copied to definitions/your-basebox/servtag-postinstall.sh and that should be run by veewee
# 
# use: zuerst configure
# after: build/make 
#
#	src: http://www.dejonghenico.be/unix/create-vagrant-base-boxes-veewee
#
#################

# The template that will be use to create the basebox
vagrant_template="ubuntu-11.10-server-amd64"
baseboxname="servtag-test3"

#######################################################
# Helpers
#
#######################################################

# Format the ouput to inform the user of his configuration
function helper_writeinformation () {
	if [$last_return_status -eq 0] then
		status="OK"
	else
		status="failed"
	fi
	echo $last_message_status."..............................[".$status."]"
	#echo "dol1 ok/failed=".$last_return_status
	#echo "dol2 msg=".$last_message_status
	#return $1
}

#######################################################
# Verification of the system
#	./configure-like
#######################################################
function configuration_checker() {
	# check 1: are we in the good directory?
	# use pwd? ls?
	last_return_status=1
	last_message_status="pending(not implemented)"
	helper_writeinformation
	
	# check 2: do we have ./veewee created?
	# ls... easy

	# check 3: do we have every software we need?
	# Which?

	# check4: would it be possible to check if the bios is correctly configured?

	 # Do we have an iso in baseboxes/iso ?
}

#######################################################
# Creation of the basebox
#
# Create a basebox
# Create the definitions/yourbasebox/servtag-postinstall.sh file
# let 
#######################################################
function  basebox_creation_runner() {
	# Building the box
	vagrant basebox define $baseboxname $vagrant_template

	
	# Copy the post-postinstall.sh script
	mv .servtag-postpostinstall.sh ./definitions/$baseboxname/.servtag-postinstall.sh
	

	# We add our work at the end of the post-install file
	# cf http://www.commentcamarche.net/forum/affich-1533480-bash-insertion-d-une-ligne-dans-un-fichier
	sed -i -e ':a;N;$!ba;s/\n/\\n/g' test1 #remplacing EOL by \n
	sed -i -e "s/exit*$/`cat .servtag-postpostinstall.sh`\nexit/g" definitions/test1/postinstall.sh


	# do it!
	vagrant basebox build '$baseboxname'

	#starting it?
	#vagrant basebox validate servtag-test3
	#vagrant basebox export 'servtag-test3'
	# vagrant box add definitions/servtag-test3/ servtag-test3.box 
	#vagrant init 'servtag-test3'
	#vagrant up
	#vagrant ssh


}

#######################################################
# run
#
#######################################################
echo "CONFIGURATION"
echo "============="
configuration_checker
echo "CREATION OF THE BASEBOX"
echo "============="
basebox_creation_runner

exit 0
