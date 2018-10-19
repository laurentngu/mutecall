#!/bin/bash
RED='\033[0;31m'
NC='\033[0m'
if  [ `date +"%M"` -le 35 ];
then echo "It is too early: the statistics from last hour are not yet generated. Retry after" `date +"%H"`":35"
exit 1
else
a=`~/mutecall/findcell_2.sh $1`
ret=`echo $?`
if [ $ret -eq 1 ]
then echo "error CI "$1" not found in that OMC-R SE1";exit 1 
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
dl=`awk '/LLC_THROUGHPUT/ {s=1} s;/P541B/ {s=0}' $gprsfile|awk '$4=='"$CI"' {print $431 +$727 + $728 +$729 + $730+ $731 + $732}'`
ul=`awk '/LLC_THROUGHPUT/ {s=1} s;/P541B/ {s=0}' $gprsfile|awk '$4=='"$CI"' {print $315 +$435 + $646 +$647 + $648}' `
#     data=`./doublecheck.sh $pcuid $CI`
#     dl=`echo $data|awk '{print $1}'`
#     ul=`echo $data|awk '{print $2}'`
#     gprsfile=`echo $data|awk '{print $3}'`
#echo "gprsfile="$gprsfile

##/alcatel/var/share/AFTR/APME/OBSYNT/Ann_Lesile_B_3/20161005/R11000009.279
nballoc=`awk '/MC01/ {s=1} s;/TRXID/ {s=0}' $gsmfile|awk '$4=='"$CI"' && (length($12)!=0 && length($113)!=0)  {print ($112 + $113)} ' `
dur=`awk '/MC01/ {s=1} s;/TRXID/ {s=0}' $gsmfile|awk '$4=='"$CI"' && (length($14)!=0 && length($115)!=0)  {print ($114 + $115)} ' `
#nballoc=`awk '$4=='"$CI"' && length($115)!=0  {print ($112 + $113)} ' $gsmfile`
#echo "nballoc="$nballoc
if [ -z "$nballoc" ]
then echo $gsmfile" is corrupted. I find nb allocation has no value"
exit 1
fi

###date
##echo "gsmfile="$gsmfile
if [ ${nballoc} -ne 0 ]
then
duration=`awk '/MC01/ {s=1};s; /TRXID/ {s=0}' $gsmfile |awk '$4=='"$CI"' && length($115)!=0 && length($114)!=0 && length($113)!=0&&length($112)!=0 {print ($114+$115)/($112+$113) }' `
#duration=`awk '$4=='"$CI"' && length($115)!=0 && length($114)!=0 && length($113)!=0&&length($112)!=0 {print ($114+$115)/($112+$113) }' $gsmfile`
else 
echo -n "no voice call on last hour" #, nb_alloc="${nballoc} " duration="$dur; 
# add a test if $dl or $ul empty string.   [ -z $dl ] || [ -z $ul ]
   if [ $dl -eq 0 ] && [ $ul -eq 0 ]
   then
   echo -n " ; no GPRS TBF at all"
   else
   echo -n "; nb DL TBF requests= "$dl
   echo -n "; nb UL TBF requests= "$ul
   fi
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

if ([ -z "$dl" ] || [ -z "$ul" ])
then 
     ##echo "cell " $CI " not found in the OBSYNT GPRS, so we will use GPMRES raw file"
     data=`~/mutecall/doublecheck2.sh $pcuid $CI`
     dl=`echo $data|awk '{print $1}'`
     ul=`echo $data|awk '{print $2}'`
     gprsfile=`echo $data|awk '{print $3}'`
     ##echo "gprsfile="$gprsfile
##else
##echo "gprsfile="$gprsfile
fi
#echo -n " call duration average="$duration
echo -n " call duration average="$rduration
echo -n "; nb DL TBF requests= "$dl
echo -n "; nb UL TBF requests= "$ul

if [ -z "$duration" ]
then echo "error, cell " $CI " not found in the OBSYNT Voice"
exit 1
fi

if [ $dl -eq 0 ] || [ $ul -eq 0 ] && [ $rduration -le 23 ]
then echo -n "; MUTE CALL DETECTED  Alert ; CI=" $1 " ."
#else  echo -e "\nRESULT: no problem on CI=" $1
fi
fi  #  test time
exit 0
