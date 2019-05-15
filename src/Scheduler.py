import sched, time
from enum import Enum
from pprint import pprint

def create_scheduler():
    return sched.scheduler(time.monotonic, time.sleep)

def sched_periodic(scheduler, task):
    scheduler.enterabs(task.delta, task.priority, sched_sporadic,
                (scheduler, task))
    task.func(**task.args)

def sched_sporadic(scheduler, task):
    scheduler.enter(task.delta, task.priority, sched_sporadic,
                (scheduler, task))
    task.func(**task.args)

def sched_aperiodic(scheduler, task):
    scheduler.enterabs(task.delta, task.priority, task.func, kwargs=task.args)

# Generic task for the scheduler
class Task:
    def __init__(self, delta, priority, func, args=()):
        self.delta = delta / float(1000)
        self.priority = priority
        self.func = func
        self.args = args


