import socket

def create_udp_socket():
    try:
        sock = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
        return sock
    except socket.error:
        pass

def create_bind_udp_socket(ip_address, port):
    try:
        sock = create_udp_socket()
        sock.bind((ip_address, port))
        sock.setblocking(0)
        return sock
    except socket.error:
        pass