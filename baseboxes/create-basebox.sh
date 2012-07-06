#!/bin/bash
#
# Can also be started by ../script/basebox-creation
#
# Script for configuration and installation of the basebox-we-need with veewee.
# * creation of the basebox
# * creation of a servtag-postinstall.sh script that will be copied to definitions/your-basebox/servtag-postinstall.sh and that should be run by veewee
#
# src: http://www.dejonghenico.be/unix/create-vagrant-base-boxes-veewee

#######################################################
# Script variables
#
#######################################################
# The template that will be use to create the basebox
vagrant_template="ubuntu-11.10-server-amd64"
# The name of the basebox
baseboxname='dealomio-test12'

system_password="vagrant"
mysql_password="root"

#######################################################
# Helpers
#
#######################################################
#
# clean the variable between 2 call
function clean_informations () {
	last_return_status=1
	status="failed"
	last_message_status="void"
}

#
# Format the ouput to inform the user of his configuration
function helper_writeinformation () {
	total=`tput cols`
		total=$[$total-20]
	if [ $last_return_status == 0 ]; then
		status="OK"
	else
		status="failed"
		total=$[$total-4]
	fi

	i="0"
	fullfill=""
	while [ $i -lt $[$total-${#last_message_status}] ]
	do
		fullfill=$fullfill.
		i=$[$i+1]
	done
	

	echo "	"$last_message_status" $fullfill["$status"]"

	clean_informations
}

#######################################################
# display the help
#######################################################
function show_help() {
	echo "Usage: $0 command"
	echo ""
	echo "Command list:"
	echo "	[-c|--check|check]	 check your configuration"
	echo "	[-h|--help|help]	 display this help"
	echo "	[-r|--run|run]		 create the basebox"


}
#######################################################
# Verification of the system
#	./configure -like
#######################################################
function configuration_checker() {
	# check 1: do we are in ./baseboxes?
	tmp=`pwd`
	last_message_status="script called from ./baseboxes/ ?"
	if [[ "$tmp" == *"/baseboxes"* ]]; then
		last_return_status=0
	else
		last_return_status=1
	fi
	helper_writeinformation

	# check 2: do we have every software we need?
	tmp=""
	tmp=`which vagrant`
	tmp2=""
	tmp2=`which veewee`
	last_message_status="vagrant installed?"
	if [ $tmp != "" ]; then
		last_return_status=0
	else
		last_return_status=1
	fi
	helper_writeinformation

	# check 3: do we have every software we need?
	tmp=""
	tmp=`which veewee`
	last_message_status="veewee installed?"
	if [ $tmp != "" ]; then
		last_return_status=0
	else
		last_return_status=1
	fi
	helper_writeinformation

	# check 4: do we ever have a basebox called $baseboxname?
	tmp=""
	tmp=`vagrant basebox list |grep $baseboxname`
	last_message_status="basebox $baseboxname already exists? $tmp"

	if [ "$tmp" == '' ]; then
		last_return_status=0
	else
		last_return_status=1
	fi
	helper_writeinformation	

	# check 5: do we ever have a basebox called $baseboxname?
	tmp=""
	tmp=`vagrant box list |grep $baseboxname`
	last_message_status="box $baseboxname already exists?$tmp"

	if [ "$tmp" == '' ]; then
		last_return_status=0
	else
		last_return_status=1
	fi
	helper_writeinformation	

	# check6: would it be possible to check if the bios is correctly configured?

	# check7: do we have a iso directory
	last_message_status="./iso/ directory exists ?"

	if [ -d 'iso' ]; then
		last_return_status=0
	else
		last_return_status=1
	fi
	helper_writeinformation	


	# check7: do we have a iso directory
	tmp=""
	tmp=`ls iso/ |grep $vagrant_template.iso`
	last_message_status="iso/ contains the iso ?"

	if [ "$tmp" == '' ]; then
		last_return_status=1
	else
		last_return_status=0
	fi
	helper_writeinformation	

	# check8: Are &baseboxname and ../config/application.yml vagrant.base_box dasselber?
	last_message_status="basebox_name equality in this script and application.yml"
	var=`cat ../config/application.yml |grep base_box: | cut -d: -f2`
	if [[ "$var" =~  $baseboxname ]]; then
		last_return_status=0
	else
		last_return_status=1
	fi
	helper_writeinformation

	# check Z: writing pending
	last_return_status=1
	last_message_status="CONFIGURATION ..... pending(not implemented)"
	helper_writeinformation
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
	sed -i -e 's/en_US/de_DE/g' definitions/$baseboxname/preseed.cfg
	sed -i -e 's/method=us/method=de/g' definitions/$baseboxname/definition.rb
	sed -i -e 's/layout=USA/layout=de/g' definitions/$baseboxname/definition.rb
	sed -i -e 's/variant=USA/variant=DE/g' definitions/$baseboxname/definition.rb

	# Moving our postinstall file and saying vagrant it has to be launched
	cp .servtag-postpostinstall.sh definitions/$baseboxname/servtag-postinstall.sh
	sed -i -e 's/"],/", "servtag-postinstall.sh"], /g' definitions/$baseboxname/definition.rb

	# Changing the passwords
	sed -i -e "s/user-password password vagrant/user-password password $system_password/g" definitions/$baseboxname/preseed.cfg
	sed -i -e "s/user-password-again password vagrant/user-password-again password $system_password/g" definitions/$baseboxname/preseed.cfg
	sed -i -e "s/root_password password vagrant/root_password password $mysql_password/g" definitions/$baseboxname/servtag-postinstall.sh
	sed -i -e "s/root_password_again password vagrant/root_password_again password $mysql_password/g" definitions/$baseboxname/servtag-postinstall.sh
	sed -i -e "s/:ssh_password => \"vagrant\"/ :ssh_password => \"$system_password\"/g" definitions/$baseboxname/definition.rb

	#changing the way ruby is installed (deleted in postinstall, properly afterwards in servtag-postinstall.sh)
	sed -i -e "s/wget http:\/\/ftp.ruby-lang.org\/pub\/ruby\/1.9\/ruby-1.9.2-p290.tar.gz//g" definitions/$baseboxname/postinstall.sh
	sed -i -e "s/tar xvzf ruby-1.9.2-p290.tar.gz//g" definitions/$baseboxname/postinstall.sh
	sed -i -e "s/cd ruby-1.9.2-p290//g" definitions/$baseboxname/postinstall.sh
	sed -i -e "s/.\/configure --prefix=\/opt\/ruby//g" definitions/$baseboxname/postinstall.sh
	sed -i -e "s/make install//g" definitions/$baseboxname/postinstall.sh
	sed -i -e "s/^make//g" definitions/$baseboxname/postinstall.sh
	sed -i -e "s/rm -rf ruby-1.9.2-p290//g" definitions/$baseboxname/postinstall.sh
	sed -i -e "s/wget http:\/\/production.cf.rubygems.org\/rubygems\/rubygems-1.8.11.tgz//g" definitions/$baseboxname/postinstall.sh
	sed -i -e "s/tar xzf rubygems-1.8.11.tgz//g" definitions/$baseboxname/postinstall.sh
	sed -i -e "s/cd rubygems-1.8.11//g" definitions/$baseboxname/postinstall.sh
	sed -i -e "s/\/opt\/ruby\/bin\/ruby setup.rb//g" definitions/$baseboxname/postinstall.sh
	sed -i -e "s/^cd \.\.$//g" definitions/$baseboxname/postinstall.sh
	sed -i -e "s/rm -rf rubygems-1.8.11//g" definitions/$baseboxname/postinstall.sh
	sed -i -e "s/\/opt\/ruby\/bin\/gem install chef --no-ri --no-rdoc//g" definitions/$baseboxname/postinstall.sh
	sed -i -e "s/\/opt\/ruby\/bin\/gem install puppet --no-ri --no-rdoc//g" definitions/$baseboxname/postinstall.sh
	sed -i -e "s/echo 'PATH=\$PATH:\/opt\/ruby\/bin\/'> \/etc\/profile.d\/vagrantruby.sh//g" definitions/$baseboxname/postinstall.sh
	
.	# Just build it! (will start at the end the modified postinstall.sh and servtag-postinstall.sh)
	# -n because on t5 we do have No GUI
	vagrant basebox build $baseboxname -n

	# Exporting the box to vagrant
	vagrant basebox export $baseboxname
	vagrant box add $baseboxname ./$baseboxname.box 
	vagrant init $baseboxname
	vagrant up
}

#######################################################
# run
#
#######################################################
if [ "$1" == "-h" -o "$1" == "--help" -o "$1" == "help" ]; then
	show_help
	exit 0;
elif [ "$1" == "-c" -o "$1" == "--check" -o "$1" == "check" ]; then
	echo ""
	echo "CONFIGURATION"
	echo "============="
	configuration_checker
elif [ "$1" == "-r" -o "$1" == "--run" -o "$1" == "run" ]; then
	echo ""
	echo ""
	echo "CREATION OF THE BASEBOX"
	echo "======================="
	basebox_creation_runner
else
	show_help
	exit 0;
fi


exit 0
