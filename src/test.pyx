#!/usr/bin/env python
import scheduler
import signal
import sys
import time
import functools
cimport c_utils

task_times = {}
times_record = {}

def main():
    # Init system
    init()

    # Periodic
    t1 = scheduler.Task(1000, 1, task_debug, 't1')
    t3 = scheduler.Task(1700, 1, task_debug, 't3')
    t6 = scheduler.Task(2000, 1, task_debug, 't6')
    # Sporadic
    t2 = scheduler.Task(1500, 1, task_debug, 't2')
    t4 = scheduler.Task(500, 1, task_debug, 't4')
    t5 = scheduler.Task(100, 1, task_debug, 't5')
    # Aperiodic
    #t7 = scheduler.Task(100, 1, task_one_shot, 't7')
    
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
    #scheduler.sched_aperiodic(s, t7)

    s.run()

def init():
    signal.signal(signal.SIGINT, signal_handler)

def task_debug(id):
    if id not in task_times:
        task_times[id] = c_utils.timer_monotonic()
    else:
        d = c_utils.timer_monotonic() - task_times[id]
        task_times[id] = c_utils.timer_monotonic()
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

def test_timers():
    print(time.monotonic())
    print(c_utils.timer_monotonic())
    time.sleep(1)
    print(time.monotonic())
    print(c_utils.timer_monotonic())
    sys.exit(0)

if __name__ == "__main__":
    main()