echo 'making dir..'
mkdir -p /root/Desktop/lab/$1/report
echo 'do nmap scan...'
nmap -A $1 -o /root/Desktop/lab/$1/report/nmap_general_report
echo 'SUCCESS!'
