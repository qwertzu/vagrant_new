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
function helper_writeinformation () {
	echo "dol1 ok/failed=".$last_return_status
	echo "dol2 msg=".$last_message_status

	return $1
}

#######################################################
# Verification of the system
#	./configure-like
#######################################################
function configuration_checker() {

	# check 1: are we in the good directory?
	# use pwd? ls?
	last_return_status=1
	last_message_status="current directoy "
	helper_writeinformation
	
	

	# check 2: do we have ./veewee created?
	# ls... easy

	# check 3: do we have every software we need?
	# Which?

 # Do we have an iso in */+ ?

}

#######################################################
# Creation of the basebox
#
#######################################################
function  basebox_creation_runner() {
	# Building the box
	vagrant basebox define $baseboxname $vagrant_template

	
	# Copy the post-postinstall.sh script
	mv .servtag-postpostinstall.sh ./definitions/$baseboxname/.servtag-postinstall.sh
	

	# am ende von post-install ajouter une ligne: exec me post-postinstall.sh
	# cf http://www.commentcamarche.net/forum/affich-1533480-bash-insertion-d-une-ligne-dans-un-fichier
	sed -i -e "s/exit*$/.servtag-postinstall.sh\nexit*$/g" definitions/test1/postinstall.sh

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
configuration_checker
basebox_creation_runner

exit 0
