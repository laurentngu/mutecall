#/bin/sh
#set -x
clear
latest=`ls -rt /alcatel/var/share/AFTR/ACME/BSSCon*|tail -1`
A=`awk '/START CELL_SECTION/ {show=1} show;/END CELL_SECTION/ {show=0}' $latest| awk -F\, '{print $5} ' |  \
grep -v CELL_CI |grep -v "^$"`
exec 1> >(tee -a ./allnetwork.log) 2>&1
 i=0 
 for k in `echo $A`   # k is the iterator  echo $A is the whole list of CELL_ID
 do 
#i=`expr $i + 1`; echo $i
#echo "CI="$k 
    ./mutecall_4_network.sh $k
  # echo -e "\n"
 done

exit 0
