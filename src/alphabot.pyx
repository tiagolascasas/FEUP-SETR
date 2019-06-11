# distutils: language=c++
import sys
import signal
import socket
import utils
import alphabot_hpi
import random
from functools import partial
from scheduler import Task, create_scheduler, sched_sporadic, sched_periodic
from libcpp.queue cimport queue
from queue import *

# Global constants
ALPHABOT_PORT = 13450
CONTROLLER_IP = utils.getLocalIP()
MESSAGE_SIZE = 500
MOVES = ['w', 'a', 's', 'd', 'i', 'j', 'k', 'l', 'q', 'e', 'o', 'u'
            'W', 'A', 'S', 'D', 'I', 'J', 'K', 'L', 'Q', 'O', 'E', 'U']

LOW_SPEED = 30
MEDIUM_SPEED = 50
HIGH_SPEED = 80

HIGH_SPEED_TIME = 3.0
HIGH_SPEED_CD = 7.0

LOW_SPEED_TIME = 3.0
LOW_SPEED_CD = 3.0

LOW_SPEED_PROBABILITY = 5

# Global variables
cdef queue[char] buff
cdef queue[char] events

can_move = True

high_speed_state = False
low_speed_state = False


sock = None
hpi = None



def main():
    print("Starting AlphaBot2 program...")
    init()

    sched = create_scheduler()

    t1 = Task(50, 2, task_read_from_socket, None) #20
    t2 = Task(10, 1, task_process_command, None) #10
    t3 = Task(300, 3, task_check_collision_sensor, sched) #40
    t4 = Task(25, 3, task_aperiodic_task_server, None) #25
    t5 = Task(2000, 4, task_rng_low_speed, None)

    sched_sporadic(sched, t1)
    sched_periodic(sched, t2)
    sched_periodic(sched, t3)
    sched_periodic(sched, t4)
    sched_periodic(sched, t5)
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
        if (c in MOVES):
            buff.push(ord(c))


def task_process_command(arg):
    global high_speed_state
    global low_speed_state
    global can_move

    if buff.empty():
        return

    c = chr(buff.front())
    buff.pop()
    
    if not can_move:
        hpi.backward()
        print("Backwards in beep")
        return

    if c.upper() == 'A' or c.upper() == 'J':
        hpi.left()
        print("Left")
    elif c.upper() == 'S' or c.upper() == 'K':
        hpi.backward()
        print("Backward")
    elif c.upper() == 'D' or c.upper() == 'L':
        hpi.right()
        print("Right")
    elif c.upper() == 'W' or c.upper() == 'I':
        hpi.forward()
        print("Forward")
    elif c.upper() == 'E' or c.upper() == 'U':
        hpi.stop()
        print("STOP")
    elif (c.upper() == 'O' or c.upper() == 'Q') and not high_speed_state: 
        hpi.set_speed(HIGH_SPEED)
        register_aperiodic_task(2, HIGH_SPEED_TIME)
        high_speed_state=True
        low_speed_state=False
        print("HIGH_SPEED")

def task_check_collision_sensor(scheduler):
    global can_move
    if not can_move:
        return
    if hpi.detect_collisions():
        hpi.set_beep(True)
        can_move = False
        register_aperiodic_task(1, 1.0)


def task_reactivate_motion(arg):
    global can_move
    hpi.set_beep(False)
    can_move = True
    hpi.stop()

def task_aperiodic_task_server(arg):
    if events.empty():
        return
    
    event = events.front()
    events.pop()
    
    if event == 1:
        task_reactivate_motion(None)
    elif event == 2: 
        task_end_high_speed_state(None)
    elif event == 3: 
        task_end_high_speed_cd(None) 
    elif event == 4: 
        task_end_low_speed_state(None)
    elif event == 5: 
        task_end_low_speed_cd(None) 


def task_end_high_speed_state(arg):
    global high_speed_state
    if high_speed_state:
        hpi.set_speed(MEDIUM_SPEED)
        register_aperiodic_task(3, HIGH_SPEED_CD)
        print("ENDHIGHSPEED")

def task_end_high_speed_cd(arg):
    global high_speed_state
    high_speed_state=False
    print("ENDHIGHSPEEDCD")

def task_rng_low_speed(arg):
    global low_speed_state
    global high_speed_state
    random_number = random.random() * 100
    if not low_speed_state and random_number < LOW_SPEED_PROBABILITY:
        high_speed_state=False
        low_speed_state=True
        hpi.set_speed(LOW_SPEED)
        register_aperiodic_task(4, LOW_SPEED_TIME)
        print("LOWSPEED")


def task_end_low_speed_state(arg):
    if low_speed_state:
        hpi.set_speed(MEDIUM_SPEED)
        register_aperiodic_task(5, LOW_SPEED_CD)
        print("ENDLOWSPEED")

def task_end_low_speed_cd(arg):
    global low_speed_state
    low_speed_state=False
    print("ENDLOWSPEEDCD")

# Helper functions
def signal_handler(sig, frame):
    print('Ending AlphaBot2 program...')
    sys.exit(0)
    
def register_aperiodic_task(func_id, delta):
    signal.signal(signal.SIGALRM, partial(enqueue_task, func_id))
    signal.setitimer(signal.ITIMER_REAL, delta)

def enqueue_task(func_id, signum, frame):
    events.push(func_id)


if __name__ == "__main__":
    main()
