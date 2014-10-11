#old buffer
buffer = raw_input('Enter the buffer you want modify: ')
#which pattern i have to find
pattern = raw_input('Enter the hex pattern in reverse order: ')


#encode in hex the buffer
hexbuffer = buffer.encode('hex')
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
    print '"A"*' + str(position) + ' + "B"*4 +"C"*' + str((len(buffer) - 4 - position))



