from netaddr import IPNetwork
import subprocess
import re

network = '192.168.10.0/23'
processes = []
for ip in IPNetwork(network):
  proc = subprocess.Popen('ping -c 1 '+str(ip)+' &',shell = True ,stdout = subprocess.PIPE)
  processes.append(proc)

for p in processes:
  p.wait()

for proc in processes:
  output,error = proc.communicate()
  if re.search('bytes from', output):
    match = re.search('[0-9]*\.[0-9]*\.[0-9]*\.[0-9]*', output)
    print match.group(0)


