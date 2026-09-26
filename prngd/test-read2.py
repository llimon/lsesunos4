import socket

s = socket.socket(socket.AF_UNIX, socket.SOCK_STREAM)
s.connect("/dev/egd-pool")

# Send command 0x02 (get entropy) asking for 16 bytes (\x10)
s.send("\x02\x10")

data = s.recv(64)
print "Received entropy bytes length:", len(data)
if len(data) == 0:
    print "Pool might still be accumulating initial entropy from gatherers."
else:
    print "Success! Data:", repr(data)
s.close()
