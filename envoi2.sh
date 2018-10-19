#!/bin/bash
dat=`date +"%d_%m_%Y"`
date> ~axadmin/mutecall/mutecall-`echo ${dat}`.csv
echo -e "" >>~axadmin/mutecall/mutecall-`echo ${dat}`.csv
a=`grep "MUTE CALL" ~axadmin/mutecall/mutecall-\`echo ${dat}\` | tr -s "." "\n"`
if [ -z "$a" ]
then echo "NO MUTE CALL DETECTED on last hour" >>~axadmin/mutecall/mutecall-`echo ${dat}`.csv
else echo -e "MUTE CALL DETECTED: \n" "$a" >>~axadmin/mutecall/mutecall-`echo ${dat}`.csv
fi

echo -e "\n">> ~axadmin/mutecall/mutecall-`echo ${dat}`.csv
echo "----------------------------------------------------------------------------------">> ~axadmin/mutecall/mutecall-`echo ${dat}`.csv
#egrep "average|MUTE" ~axadmin/mutecall/mutecall-`echo ${dat}` >> ~axadmin/mutecall/mutecall-`echo ${dat}`.csv
cat ~axadmin/mutecall/mutecall-`echo ${dat}` >> ~axadmin/mutecall/mutecall-`echo ${dat}`.csv
mailx -v  -S smtp="10.162.168.195:25" -s "mutecall 48H : `date +\"%d/%m/%Y\"` OMCR SE1 LYON" -a ~axadmin/mutecall/mutecall-`echo ${dat}`.csv lromeiro.ext@orange.com \
<~axadmin/mutecall/mutecall-`echo ${dat}`.csv
