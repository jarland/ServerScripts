# Update serial numbers for all zone files on my cPanel servers
# The "2015080709" should be replaced as needed. It's year+month+day+revision

sed -i 's/20[0-9][0-9]\{7\}/2015080709/g' /var/named/*.db
rndc reload
