#!/usr/bin/env python
import scheduler
import signal
import sys
import time
import functools

task_times = {}
times_record = {}

def main():
    # Init system
    init()

    # Periodic
    t1 = scheduler.Task(1000, 1, task_debug, {'id': 't1'})
    t3 = scheduler.Task(1700, 1, task_debug, {'id': 't3'})
    t6 = scheduler.Task(2000, 1, task_debug, {'id': 't6'})
    # Sporadic
    t2 = scheduler.Task(1500, 1, task_debug, {'id': 't2'})
    t4 = scheduler.Task(500, 1, task_debug, {'id': 't4'})
    t5 = scheduler.Task(100, 1, task_debug, {'id': 't5'})
    # Aperiodic
    t7 = scheduler.Task(100, 1, task_one_shot, {'arg': 't7'})
    
    s = scheduler.create_scheduler()

    # Schedule periodic
    scheduler.sched_periodic(s, t1)
    scheduler.sched_periodic(s, t3)
    scheduler.sched_periodic(s, t6)
    # Schedule sporadic
    scheduler.sched_sporadic(s, t2)
    scheduler.sched_sporadic(s, t4)
    scheduler.sched_sporadic(s, t5)
    # Schedule aperiodic
    scheduler.sched_aperiodic(s, t7)

    s.run()

def init():
    signal.signal(signal.SIGINT, signal_handler)

def task_debug(id):
    if id not in task_times:
        task_times[id] = time.monotonic()
    else:
        d = time.monotonic() - task_times[id]
        task_times[id] = time.monotonic()
        print("Task %s: %s" % (id, round(d * 1000)))
        if id not in times_record:
            times_record[id] = []
        times_record[id].append(round(d * 1000))

def task_one_shot(arg):
    print("Task %s" % arg)

def print_avg_times():
    print("here")
    for task, times in times_record.items():
        avg = functools.reduce(lambda t1, t2: t1 + t2, times) / len(times)
        print("Task %s: avg time %s" % (task, round(avg)))

def signal_handler(sig, frame):
        print_avg_times()
        sys.exit(0)

if __name__ == "__main__":
    main()