# distutils: language=c++
import sys, signal, socket, utils, alphabot_hpi
from scheduler import Task, create_scheduler, sched_sporadic, sched_periodic
from libcpp.queue cimport queue

# Global constants
ALPHABOT_PORT = 13450
CONTROLLER_IP = "127.0.0.1"
MESSAGE_SIZE = 500
MOVES = ['w', 'a', 's', 'd', 'i', 'j', 'k', 'l', 'q', 'o','W', 'A', 'S', 'D', 'I', 'J', 'K', 'L','Q', 'O']
LOW_SPEED = 30
MEDIUM_SPEED = 50
HIGH_SPEED = 80

# Global variables
cdef queue[char] buff
can_move = True
high_speed_state=False
low_speed_state=False
timer_high_speed_state=False
times_low_speed_state=False
sock = None
hpi = None

##TODO TASK COM PROBABILIDADE DE FICAR LENTO
##TODO TASK PARA VOLTAR A POR A VELOCIDADE NORMAL
##TODO TASK PARA REACTIVE MOTION
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
        if (c in MOVES):
            buff.push(ord(c))

def task_process_command(arg):
    if buff.empty():
        return
    
    c = chr(buff.front())
    buff.pop()

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
    elif c.upper() == 'O' or c.upper()=='Q':
        hpi.set_speed(HIGH_SPEED)
    
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