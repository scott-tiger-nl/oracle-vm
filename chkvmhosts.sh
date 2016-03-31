#!/bin/bash
# ======================================================================
# file        : chkvmhosts.sh
# description : Display shortname an memo of all vm.cfg files in your
#             : Oracle VM environment. Run this on one of your OVM server.
#             : Change variable OVM_REPOS, with your repository location(s).
# history     : 31-03-2016 PL - created
# license     :
# Copyright (C) 2016  Peter Lengkeek
#
# This code is free software; you can redistribute it and/or
# modify it under the terms of the GNU General Public License
# as published by the Free Software Foundation; either version 2
# of the License, or (at your option) any later version.
#
# This code is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this code; if not, write to the Free Software
# Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.
# ======================================================================
# -- setup --
OVS_REPOS="/OVS/Repositories/0004fb00000300008ef0d3549957dbf3
/OVS/Repositories/0004fb00000300004de1ff514d9291c0"

# -- main --
for REPO in `echo $OVS_REPOS`
do
 echo $REPO
 cd $REPO/VirtualMachines
 find . -name vm.cfg | while read VM_CFG
 do
   cat $VM_CFG | grep -e 'OVM_simple_name =' -e 'memory = ' | while read LINE
   do
#     echo LINE=$LINE
     NAME=`echo $LINE | sed 's/ //g' | awk -F= '{print $1}'`
     VALUE=`echo $LINE | sed 's/ //g' | awk -F= '{print $2}'`
#     echo "--> [$NAME] [$VALUE]"
     if [ "$NAME" = "OVM_simple_name" ]; then
        VM_HOST=`echo $VALUE | sed "s/'//g"`
     fi
     if [ "$NAME" = "memory" ]; then
        VM_MEM=$VALUE
        echo "$VM_HOST $VM_MEM"
     fi

   done
 done
done
# -- end of script --
