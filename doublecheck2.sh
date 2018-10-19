#!/bin/bash
fil=`ls -rt  /alcatel/var/share/AFTR/APME/MFS/*GPMRES*${1}*.gz|tail -1`
file=`ls -rt  /alcatel/var/share/AFTR/APME/MFS/*GPMRES*${1}*.gz|tail -1|cut -d\/ -f8`
mkdir tempo.$$
cp -p /alcatel/var/share/AFTR/APME/MFS/$file ./tempo.$$
#ls -l $file
gzip -d -f ./tempo.$$/$file
file=`echo $file|sed -e "s@.gz@@"`
#echo " CI=$2"
CI_num=$2
#awk '/CI 63758/{flag=1;next}/{/{flag=0}flag' $1 
#echo $CI_file

awk ' /^CI '"$CI_num"'$/{flag=1;next}/{/{flag=0}flag' ./tempo.$$/$file| \
awk '/P91a/||/P91b/||/P91c/||/P91d/||/P91e/||/P91f/||/P505/ {sum +=$2} END{print sum}'


awk '/^CI '"$CI_num"'$/{flag=1;next}/{/{flag=0}flag' ./tempo.$$/$file| \
awk '/P62a/||/P62b/||/P62c/||/P507/{sum1 +=$2} /P438c/ {sum2+=$2}END{print sum1-sum2}' 

#echo -e "\n"  # that is to jump one line
echo $fil
\rm -r tempo.$$
exit 0
