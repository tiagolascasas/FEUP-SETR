# distutils: language = c++
import curses, inspect, sys, signal
from scheduler import Task, create_scheduler, sched_sporadic
from libcpp.queue cimport queue

# Global variables
screen = curses.initscr()
cdef queue[char] buff

# Init
def main():
    init()

    t1 = Task(0.01, 1, task_read_from_keyboard, None)

    sched = create_scheduler()
    sched_sporadic(sched, t1)
    sched.run()

def init():
    screen.nodelay(True)
    curses.noecho()
    curses.cbreak()
    signal.signal(signal.SIGINT, signal_handler)

# Task functions
def task_read_from_keyboard(arg):
    key = screen.getch()
    if key > -1:
        buff.push(key)

# Helper functions
def signal_handler(sig, frame):
        print('Ending control program...')
        curses.echo()
        curses.nocbreak()
        curses.endwin()
        sys.exit(0)

if __name__ == "__main__":
    main()