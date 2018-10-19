#!/bin/bash
a=`tr -s '\015\012' ' ' < ~/mutecall/BTS.txt`
~/mutecall/mute.sh $a
exit 0
