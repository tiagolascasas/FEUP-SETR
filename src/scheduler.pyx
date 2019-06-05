import sched, time
cimport c_utils

# Models periodic, sporadic and aperiodic tasks using
# Python's generic EDF scheduler. See implementation:
# https://github.com/python/cpython/blob/3.7/Lib/sched.py

def create_scheduler():
    return sched.scheduler(c_utils.timer_monotonic, time.sleep)

def sched_periodic(scheduler, task):
    scheduler.enterabs(task.delta, task.priority, sched_sporadic,
                (scheduler, task))
    task.func(task.arg)

def sched_sporadic(scheduler, task):
    scheduler.enter(task.delta, task.priority, sched_sporadic,
                (scheduler, task))
    task.func(task.arg)

def sched_aperiodic(scheduler, task):
    scheduler.enterabs(task.delta, task.priority, task.func, (task.arg))

# Generic task for the scheduler
class Task:
    def __init__(self, delta, priority, func, arg):
        self.delta = delta / float(1000)
        self.priority = priority
        self.func = func
        self.arg = arg


