#!/bin/bash
#
#
#
# src: http://www.dejonghenico.be/unix/create-vagrant-base-boxes-veewee


cd .. && vagrant destroy --f
array1 = vagrant basebox list
array2 = vagrant box list


for i in ${!array1[*]}
do
	vagrant basebox remove ${array1[i]}
	rm -rf definitions/${array1[i]
done

for i in ${!array2[*]}
do
	vagrant basebox remove ${array2[i]}
done

rm -rf Vagrantfile
