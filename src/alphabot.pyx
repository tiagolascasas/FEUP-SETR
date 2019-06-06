# distutils: language=c++
import sys, signal, socket, utils, alphabot_hpi
from scheduler import Task, create_scheduler, sched_sporadic, sched_periodic
from libcpp.queue cimport queue

# Global constants
ALPHABOT_PORT = 13450
CONTROLLER_IP = "127.0.0.1"
MESSAGE_SIZE = 500

# Global variables
cdef queue[char] buff
can_move = True
sock = None
hpi = None

def main():
    init()
    
    t1 = Task(0.05, 1, task_read_from_socket, None)
    t2 = Task(0.05, 1, task_process_command, None)
    #t3 = Task(0.03, 1, task_send_to_alphabot, 2)

    sched = create_scheduler()
    sched_sporadic(sched, t1)
    sched_periodic(sched, t2)
    sched.run()
        
def init():
    global hpi
    global sock

    hpi = alphabot_hpi.AlphaBot2()
    sock = utils.create_bind_udp_socket(CONTROLLER_IP, ALPHABOT_PORT)

    signal.signal(signal.SIGINT, signal_handler)

# Task function
def task_read_from_socket(arg):
    msg = ""

    try:
        data, _ = sock.recvfrom(MESSAGE_SIZE)
        msg = data.decode('utf-8')
    except socket.error:
        pass

    for c in msg:
        print(c)
        buff.push(ord(c))

def task_process_command(arg):
    if buff.empty():
        return
    
    c = chr(buff.front())
    buff.pop()

    if c == 'a' or c == 'j':
        hpi.left()
    if c == 's' or c == 'k':
        hpi.backward()
    if c == 'd' or c == 'l':
        hpi.right()
    if c == 'w' or c == 'i':
        hpi.forward()
    


def task_check_collision_sensor(scheduler):
    #check collision sensor
    #if collision, deactivate motion and schedule reactivation task and activate beep
    pass

def task_reactivate_motion():
    can_move = True
    #disable beep

# Helper functions
def signal_handler(sig, frame):
        print('Ending AlphaBot2 program...')
        sys.exit(0)


if __name__ == "__main__":
    main()