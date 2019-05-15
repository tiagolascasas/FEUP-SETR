import sched, time

# Models periodic, sporadic and aperiodic tasks using
# Python's generic EDF scheduler. See implementation:
# https://github.com/python/cpython/blob/3.7/Lib/sched.py

def create_scheduler():
    return sched.scheduler(time.monotonic, time.sleep)

def sched_periodic(scheduler, task):
    scheduler.enterabs(task.delta, task.priority, sched_sporadic,
                (scheduler, task))
    task.func(**task.kwargs)

def sched_sporadic(scheduler, task):
    scheduler.enter(task.delta, task.priority, sched_sporadic,
                (scheduler, task))
    task.func(**task.kwargs)

def sched_aperiodic(scheduler, task):
    scheduler.enterabs(task.delta, task.priority, task.func, kwargs=task.kwargs)

# Generic task for the scheduler
class Task:
    def __init__(self, delta, priority, func, kwargs={}):
        self.delta = delta / float(1000)
        self.priority = priority
        self.func = func
        self.kwargs = kwargs


