import Scheduler
import time

def main():
    # Periodic
    t1 = Scheduler.Task(1000, 1, task_debug, {'id': 't1'})
    t3 = Scheduler.Task(1700, 1, task_debug, {'id': 't3'})
    t6 = Scheduler.Task(2000, 1, task_debug, {'id': 't6'})
    # Sporadic
    t2 = Scheduler.Task(1500, 1, task_debug, {'id': 't2'})
    t4 = Scheduler.Task(500, 1, task_debug, {'id': 't4'})
    t5 = Scheduler.Task(100, 1, task_debug, {'id': 't5'})
    
    s = Scheduler.create_scheduler()

    # Schedule periodic
    Scheduler.sched_periodic(s, t1)
    Scheduler.sched_periodic(s, t3)
    Scheduler.sched_periodic(s, t6)
    # Schedule sporadic
    Scheduler.sched_sporadic(s, t2)
    Scheduler.sched_sporadic(s, t4)
    Scheduler.sched_sporadic(s, t5)

    s.run()

task_times = {}

def task_debug(id, foo=None):
    if id not in task_times:
        task_times[id] = time.monotonic()
    else:
        d = time.monotonic() - task_times[id]
        task_times[id] = time.monotonic()
        print("Task %s: %s" % (id, round(d * 1000)))   

if __name__ == "__main__":
    main()