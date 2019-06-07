import socket

def create_udp_socket():
    try:
        sock = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
        return sock
    except socket.error:
        pass

def getLocalIP():
    return (([ip for ip in socket.gethostbyname_ex(socket.gethostname())[2] if not ip.startswith("127.")] or [[(s.connect(("8.8.8.8", 53)), s.getsockname()[0], s.close()) for s in [socket.socket(socket.AF_INET, socket.SOCK_DGRAM)]][0][1]]) + ["no IP found"])[0]
    
def create_bind_udp_socket(ip_address, port):
    try:
        sock = create_udp_socket()
        sock.bind((ip_address, port))
        sock.setblocking(0)
        return sock
    except socket.error:
        pass

def getAlphabotIP(hostname):
    return socket.gethostbyname(hostname)
