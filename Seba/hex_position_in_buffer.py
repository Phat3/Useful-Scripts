import subprocess
#old buffer
bufferLength = raw_input('Enter the length of the buffer you want modify: ')
#which pattern i have to find
pattern = raw_input('Enter the hex pattern in reverse order: ')
#create the patthern
p = subprocess.Popen(['/usr/share/metasploit-framework/tools/pattern_create.rb', bufferLength], stdin=subprocess.PIPE, stdout=subprocess.PIPE, stderr=subprocess.PIPE)
buffer, err = p.communicate()
#encode in hex the buffer
hexbuffer = buffer.strip().encode('hex')
#find our patter in reverse order (little endian)
position =  hexbuffer.find(pattern)
if(position == -1):
    print 'Pattern not found'
else:
    #get the substring matched and decode it as hex
    substrigBuffer =  hexbuffer[position : position + 8].decode('hex')
    #get the position of the pattern in string format in old buffer
    position = buffer.find(substrigBuffer)
    #print the formula for the new buffer
    print '"A"*' + str(position) + ' + "B"*4 +"C"*' + str((len(buffer.strip()) - 4 - position))

