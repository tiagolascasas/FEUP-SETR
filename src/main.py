from Scheduler import RTScheduler, Task, SchedUtils
import sched, time

def main():
    t1 = Task(1, 1, f1)
    t2 = Task(1.5, 1, f2)
    t3 = Task(1.7, 1, f3)
    t4 = Task(0.5, 1, f4)
    t5 = Task(0.1, 1, f5)
    t6 = Task(2, 1, f6)
    
    s = sched.scheduler(time.monotonic_ns, time.sleep)
    RTScheduler.sched_periodic(s, t1)
    RTScheduler.sched_sporadic(s, t2)
    #RTScheduler.sched_periodic(s, t3)
    RTScheduler.sched_sporadic(s, t4)
    RTScheduler.sched_sporadic(s, t5)
    #RTScheduler.sched_periodic(s, t6)
    s.run()

def f1():
    print("f1")

def f2():
    print("f2")

def f3():
    print("f3")

def f4():
    print("f4")
    
def f5():
    print("f5")
    
def f6():
    print("f6")

if __name__ == "__main__":
    main()