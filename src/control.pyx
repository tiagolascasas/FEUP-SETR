# distutils: language=c++
import curses
import sys
import signal
import socket
import utils
from scheduler import Task, create_scheduler, sched_sporadic, sched_periodic
from libcpp.queue cimport queue

# Global constants
ALPHABOT_1_IP = utils.getAlphabotIP("RASP-ALPHABOT1")
ALPHABOT_2_IP = utils.getAlphabotIP("RASP-ALPHABOT2")
ALPHABOT_PORT = 13450
MOVES_1 = ['w', 'a', 's', 'd', 'q', 'W', 'A', 'S', 'D', 'Q', 'e', 'E']
MOVES_2 = ['i', 'j', 'k', 'l', 'o', 'O', 'I', 'J', 'K', 'L', 'U', 'u']
# Global variables
screen = None
cdef queue[char] buff_1
cdef queue[char] buff_2
socket_1 = None
socket_2 = None

# Init


def main():
    init()

    t1 = Task(0.01, 1, task_read_from_keyboard, None)
    t2 = Task(0.03, 1, task_send_to_alphabot, 1)
    t3 = Task(0.03, 1, task_send_to_alphabot, 2)

    sched = create_scheduler()
    sched_sporadic(sched, t1)
    sched_periodic(sched, t2)
    sched_periodic(sched, t3)
    sched.run()


def init():
    global screen
    global socket_1
    global socket_2

    screen = curses.initscr()
    screen.nodelay(True)
    curses.initscr()
    curses.noecho()
    curses.cbreak()

    signal.signal(signal.SIGINT, signal_handler)

    socket_1 = utils.create_udp_socket()
    socket_2 = utils.create_udp_socket()

# Task functions


def task_read_from_keyboard(arg):
    key = screen.getch()
    if key > -1:
        c = chr(key)
        if c in MOVES_1:
            buff_1.push(key)
            print(key)
        if c in MOVES_2:
            buff_2.push(key)
            print(key)


def task_send_to_alphabot(alphabot):
    ip = ALPHABOT_1_IP if alphabot == 1 else ALPHABOT_2_IP
    sock = socket_1 if alphabot == 1 else socket_2
    msg = ""

    if alphabot == 1:
        if buff_1.empty():
            return

        while not buff_1.empty():
            key = buff_1.front()
            msg += chr(key)
            buff_1.pop()
    elif alphabot == 2:
        if buff_2.empty():
            return

        while not buff_2.empty():
            key = buff_2.front()
            msg += chr(key)
            buff_2.pop()

    try:
        sock.sendto(bytes(msg, 'utf-8'), (ip, ALPHABOT_PORT))
    except socket.error:
        pass

# Helper functions


def signal_handler(sig, frame):
    print('Ending control program...')
    curses.echo()
    curses.nocbreak()
    curses.endwin()
    sys.exit(0)


if __name__ == "__main__":
    main()
