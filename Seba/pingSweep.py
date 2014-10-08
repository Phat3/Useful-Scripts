import subprocess, os
#TODO da renderlo flessibile dal punto di vista della netmask(capire la lungezza della netmask e pingare tutti gli indrizzi posibili con quella netmask)
subnetMask = '255.255.254.0.0'
#TODO rendere possibile inserimento start e end da parte dell utente e fare in modo che funzioni con altre netmasck diverse dalla 24
startAddress = '192.168.31.200'
endAddress = '192.168.31.254'

'''
da implementare la flessibilita della netmask (ora non c e tempo)
conversion = ''
for part in subnetMask.split('.'):
    binary = bin(int(part)).split("0b")
    conversion = conversion + binary[1]
print conversion.count("1")
'''
#prendiamo l'ultima parte degli indirizzi
start = int(startAddress.split(".")[3])
end = int(endAddress.split(".")[3])
#inizializziamo l array dei network che rispondono al ping
responseNetwork = []
count = 0

#scorriamo tutti gli indirizzi nel range e pinghiamo la macchina
for x in xrange(start,end):
    address = '192.168.31.' + str(x)
    process = subprocess.Popen('ping -c 1 ' + address, shell = True, stdout=subprocess.PIPE)
    out, err = process.communicate()
    count = count +1
    print 'Controllati ' + str(count) + ' Indirizzi'
    #se non ho questa frase (il count e > 0) allora la macchina ha risposto
    if (out.count("Destination Host Unreachable") == 0):
        print 'Indirizzo aggiunto'
        responseNetwork.append(address)

#ricaviamo la directory dove vogliamo salvare i file partendo dalla home dell utente
directory = os.path.expanduser('~') + '/Desktop/fileUtili'
#se non esiste la directory creiamola e apriamo il file
if (os.path.isdir(directory)):
    fileOutput = open(directory + '/indirizziAttivi.txt', 'w')
else:
    os.makedirs(directory)
    fileOutput = open(directory + '/indirizziAttivi.txt', 'w')
#scriviamo il file
for addr in responseNetwork:
    fileOutput.write(addr + "\n")

print 'SUCCESS!'
