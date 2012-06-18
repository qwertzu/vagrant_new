#!/bin/bash
# 
# Destroy all the basebox and box we create

name="servtag-test12"
vagrant halt
cd .. && vagrant destroy

vagrant basebox destroy $name

rm -rf definitions/$name
rm $namebaseboxes.box

vagrant box remove $name

