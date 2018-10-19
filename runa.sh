#!/bin/bash
a=`tr -s '\015\012' ' ' < ~/mutecall/BTS.txt`
~/mutecall/mutea.sh $a
exit 0
