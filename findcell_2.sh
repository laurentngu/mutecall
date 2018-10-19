#!/bin/sh
if [ "$#" -ne 1 ]; then
    echo "enter CI please. 1 argument only"
    exit 1
fi
#echo "The Cell_CI you entered is $1"
CI=`echo $1`
latest=`ls -rt /alcatel/var/share/AFTR/ACME/BSSCon*|tail -1`
#latest=/alcatel/var/share/AFTR/ACME/${new}
#echo .the last is ${lastest}.

###  comments: filter only on section CELL 
#bsc_num=`grep -A37 $1 ${latest} | head -1 | cut -f1 -d\,`

bsc_num=`awk '/START CELL_SECTION/ {show=1} show;/END CELL_SECTION/ {show=0}' $latest|awk -F\, '$5=='"$CI"' {print $1}' | head -1` 
if [ -z $bsc_num ] 
then echo "error. CI not found";exit 1
fi

#echo "bsc_num: ${bsc_num}"

#### take section BSC only
#bsc_name=`grep -A26 "START BSC_SECTION" ${latest} | grep \^${bsc_num} | cut -d\\, -f2`
bsc_name=`awk '/START BSC_SECTION/ {show=1} show;/END BSC_SECTION/ {show=0}' ${latest} | awk -F\, '$1=='"${bsc_num}"' {print $2}'|cut -d\, -f1`

pcu_name=`grep -w ${bsc_name} ~/mutecall/Equipment.txt | cut -f1 -d\:`

pcu_id=`grep -w ${pcu_name} ~/mutecall/PCU.txt | cut -f1 -d\;`
a=`date +%Y%m%d`
aprime=`date +%Y%m%d -d "yesterday"`
b=`date "+%H"`
min=`date "+%M"`
if [ $b != "00" ]
then 
path1=`echo "/alcatel/var/share/AFTR/APME/OBSYNT/${bsc_name}/"${a}"/R110*"`
path2=`echo "/alcatel/var/share/AFTR/APME/OBSYNT/mfs${pcu_id}/"${a}"/RMFS*"`
else
  
   if [ $b == "00" ]
   then
   path1=`echo "/alcatel/var/share/AFTR/APME/OBSYNT/${bsc_name}/"${aprime}"/R110*"`
   path2=`echo "/alcatel/var/share/AFTR/APME/OBSYNT/mfs${pcu_id}/"${aprime}"/RMFS*"`
   fi
fi

a=`ls -rt  $path1`
if [ $? -eq 2 ] 
then exit 2
else echo $a|awk '{print $NF}'
fi

a=`ls -rt  $path2`
if [ $? -eq 2 ] 
then exit 3
else echo $a|awk '{print $NF}'
fi

echo ${pcu_id}
exit 0
