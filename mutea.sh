#!/bin/bash
> ~/mutecall/mutecall-`date +"%d_%m_%Y"`
exec 1> >(tee -a ~/mutecall/mutecall-`date +"%d_%m_%Y"`) 2>&1
latest=`ls -rt /alcatel/var/share/AFTR/ACME/BSSCon*|tail -1`

for i in `echo $@`
do
listCI=`awk '/START CELL_SECTION/ {show=1} show;/END CELL_SECTION/ {show=0} ' $latest |awk -v var=$i -F\, '$13==var {print $0}'\
|awk -F\, '{print $5}'`
#if [ -z "$listCI" ]
#then
#echo -e "BTS" $i" not found\n\n"
#exit 1
#else
 for ci in `echo $listCI`
 do #echo $k 
 awk '/START CELL_SECTION/ {show=1} show;/END CELL_SECTION/ {show=0} ' $latest |awk -v var=$ci -F\, '$5==var {print $0}'\
    |awk -v var=$ci -F\, '{printf $6 " ; "}'
    #|awk -v var=$ci -F\, 'function green(s){printf "\033[1;32m" s "\033[0m "} function blue(s){"\033[1;34m" s "\033[0m "}{printf  green($6) " ; "}'
    # |awk -v var=$ci -v col=$GREEN -F\, '{print $6 "   CI="var}'
~/mutecall/mutecall_4a.sh $ci
echo  -e ""
 done
#fi
done
####echo -e "\n"
exit 0
