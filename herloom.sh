mail -v  -S smtp="10.162.168.195:25" -s "$(echo -e "mutecall\nContent-Type: text/html")"  rootmaster.ext@orange.com < /alcatel/base/doc/gsm/jre_linux/Welcome.html

echo "To: address@example.com" > /var/www/report.csv
echo "Subject: Subject" >> /var/www/report.csv
echo "MIME-Version: 1.0" >> /var/www/report.csv
echo "Content-Type: text/html; charset=\"us-ascii\"" >> /var/www/report.csv
echo "Content-Disposition: inline" >> /var/www/report.csv

echo "<html>" >> /var/www/report.csv
