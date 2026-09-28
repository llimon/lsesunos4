import socket
s = socket.socket(socket.AF_UNIX, socket.SOCK_STREAM)
s.connect("/dev/egd-pool")
s.send("\x20\x10")
data = s.recv(64)
print "Received entropy bytes length:", len(data)
s.close()
