#cimport c_utils

can_move = True
#declare queue

def main():
    setup()
    
    #create schedule
    #create tasks
    #schedule tasks
    #while True:
    #    print("Alphabot running")
    #    c_utils.test()
        
def setup():
    # Open socket
    # Configure sensor pins
    pass
        
def task_read_from_socket():
    #read from socket non-blocking
    #put in queue
    pass

def task_process_command():
    #read from queue
    #process command
    pass

def task_check_collision_sensor(scheduler):
    #check collision sensor
    #if collision, deactivate motion and schedule reactivation task and activate beep
    pass

def task_reactivate_motion():
    can_move = True
    #disable beep