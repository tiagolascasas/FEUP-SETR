import sched, time
from enum import Enum
from pprint import pprint

def sched_periodic(scheduler, task):
    scheduler.enterabs(task.delta, task.priority, sched_periodic,
                (scheduler, task))
    task.func()

def sched_sporadic(scheduler, task):
    scheduler.enter(task.delta, task.priority, sched_sporadic,
                (scheduler, task))
    task.func()

def sched_periodic(scheduler, task):
    scheduler.enterabs(task.delta, task.priority, task.func)

def sleep_ms(milliseconds):
    time.sleep(milliseconds / float(1000))

# Generic task for the scheduler
class Task:
    def __init__(self, delta, priority, func, args=()):
        self.delta = delta
        self.priority = priority
        self.func = func
        self.args = args


