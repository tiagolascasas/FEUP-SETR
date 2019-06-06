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
    
    sched = create_scheduler()

    t1 = Task(0.05, 5, task_read_from_socket, None)
    t2 = Task(0.1, 5, task_process_command, None)
    t3 = Task(0.05, 5, task_check_collision_sensor, sched)

    sched_sporadic(sched, t1)
    sched_periodic(sched, t2)
    sched_periodic(sched, t3)
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
        print("Left")
    if c == 's' or c == 'k':
        hpi.backward()
        print("Backward")
    if c == 'd' or c == 'l':
        hpi.right()
        print("Right")
    if c == 'w' or c == 'i':
        hpi.forward()
        print("Forward")
    
def task_check_collision_sensor(scheduler):
    if not can_move:
        return
    if hpi.detect_collisions():
        hpi.set_beep(True)
        can_move = False

def task_reactivate_motion(arg):
    hpi.set_beep(False)
    can_move = True
    

# Helper functions
def signal_handler(sig, frame):
        print('Ending AlphaBot2 program...')
        sys.exit(0)


if __name__ == "__main__":
    main()