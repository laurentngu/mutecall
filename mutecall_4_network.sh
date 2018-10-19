#!/bin/bash
RED='\033[0;31m'
NC='\033[0m'
#if  [ `date +"%M"` -le 35 ];
if  [ `date +"%M"` -eq 350 ];
then echo "It is too early the statistics from last hour are not yet generated. Retry after" `date +"%H"`":35"
else
a=`~/mutecall/findcell_2.sh $1`
ret=`echo $?`
if [ $ret -eq 1 ]
then echo "error CI "$1" not found in that OMC-R SE2";exit 1
else
  if [ $ret -eq 2 ]
    then echo "OBSYNT voice not existing. Error";exit 1
  else
        if [ $ret -eq 3 ]; then echo "OBSYNT gprs not existing. Error";exit 1
        fi
  fi
fi


#exec 1> >(tee -a ./mutecall.log) 2>&1
#echo -e "\nCI="$1

gsmfile=`echo $a|awk '{print $1}'`
#echo "gsmfile="$gsmfile
gprsfile=`echo $a|awk '{print $2}'`
#echo "gprsfile="$gprsfile
pcuid=`echo $a|awk '{print $3}'`

CI=`echo $1`
#dl=`awk '$4=='"$CI"' {print $431 +$727 + $728 +$729 + $730+ $731 + $732}' $gprsfile`
#ul=`awk '$4=='"$CI"' {print $315 +$435 + $646 +$647 + $648}' $gprsfile`
     data=`./doublecheck2.sh $pcuid $CI`
     dl=`echo $data|awk '{print $1}'`
     ul=`echo $data|awk '{print $2}'`
nballoc=`awk '$4=='"$CI"' && length($115)!=0  {print ($112 + $113)} ' $gsmfile`
if [ -z $nballoc ]
then echo $gsmfile" is corrupted. I find nb allocation has no value"
exit 1
fi
#date
if [ ${nballoc} -ne 0 ]
then
duration=`awk '$4=='"$CI"' && length($115)!=0 && length($114)!=0 && length($113)!=0&&length($112)!=0 {print ($114+$115)/($112+$113) }' $gsmfile`
else #echo "no calls voice on last hours"; 
#echo "nb DL TBF requests= "$dl
#echo "nb UL TBF requests= "$ul
exit 0;
fi

rduration=${duration%.*}
#echo "nb DL TBF requests= "$dl
#echo "nb UL TBF requests= "$ul
#echo "call duration average="$duration
#duration=${duration%.*}

#if [ $rduration -gt 0 ] && [ $rduration -lt 21 ] && [ -z $dl ] && [ -z $ul ]
#then echo -e "\n${RED}ALERT ! Symptom of mute calls. Perform a reset of the module. CI=" $1${NC}
#fi

if [ -z $dl ] || [ -z $ul ]
then #echo "error, cell " $CI " not found in the OBSYNT GPRS"
     data=`./doublecheck2.sh $pcuid $CI`
     dl=`echo $data|awk '{print $1}'`
     ul=`echo $data|awk '{print $2}'`
#exit 1
fi

if [ -z $duration ]
then echo "error, cell " $CI " not found in the OBSYNT Voice"
exit 1
fi

if [ $dl -eq 0 ] || [ $ul -eq 0 ] && [ $rduration -le 21 ]
then echo -e "\n${RED}RESULT: that is mute calls. Alert ! Perform a reset of the module. CI=" $1${NC}
#else  echo -e "\nRESULT: no problem on CI=" $1
fi
fi  #  test time
exit 0
