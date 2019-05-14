import sched, time
from enum import Enum

class Kernel:
    def __init__(self, time_func, sleep_func):
        self.scheduler = sched.scheduler(time_func, sleep_func)

    def add_task(self, task):
        if task.task_type == TaskTypes.SPORADIC:
            self.scheduler.enter(task.delay, task.priority, task.func)
        if task.task_type == TaskTypes.PERIODIC:
            self.scheduler.enterabs(task.time, task.priority, task.func)

    def start(self):
        self.scheduler.run()
    
    @staticmethod
    def sleep_ms(time):
        time.sleep(time / 1000)

class TaskTypes(Enum):
    SPORADIC = 1
    PERIODIC = 2

class Task:
    def __init__(self, task_type, delta, priority, func):
        if task_type == TaskTypes.SPORADIC:
            self.delay = delta
        elif task_type == TaskTypes.PERIODIC:
            self.time = delta
        self.priority = priority
        self.task_type = task_type
        self.func = func

def f1():
    print("f1")

def f2():
    print("f2")

def f3():
    print("f3")

t1 = Task(TaskTypes.PERIODIC, 20, 1, f1)
t2 = Task(TaskTypes.SPORADIC, 10, 5, f2)
t3 = Task(TaskTypes.PERIODIC, 40, 10, f3)

kernel = Kernel(time.monotonic, Kernel.sleep_ms)
kernel.add_task(t1)
kernel.add_task(t2)
kernel.add_task(t3)
kernel.start()