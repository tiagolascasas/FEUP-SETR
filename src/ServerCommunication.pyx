import socket

MESSAGE_SIZE = 500

#################
# CONTROL TOWER #
#################


def create_udp_socket():
    try:
        sock = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
        return sock
    except socket.error:
        pass


def sendMessage(message, ip_address, port, sock):
    try:
        sock.sendto(bytes(message, 'utf-8'), (ip_address, port))
    except socket.error:
        pass

############
# ALPHABOT #
############


def create_bind_udp_socket(ip_address, port):
    try:
        sock = create_udp_socket()
        sock.bind((ip_address, port))
        sock.setblocking(0)
        return sock
    except socket.error:
        pass


def receive_message(sock):
    try:
        data, _ = socket1.recvfrom(MESSAGE_SIZE)
        return data.decode('utf-8')
    except socket.error:
        pass



