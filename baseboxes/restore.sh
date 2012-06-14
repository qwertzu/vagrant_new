#!/bin/bash
# 
# Destroy all the basebox and box we create

name="servtag-test10"
cd .. && vagrant destroy

vagrant basebox destroy $name

rm -rf baseboxes/definitions/$name
rm baseboxes/$namebaseboxes.box

vagrant box remove $name

