typedef struct
{
  int period;
  int del;
  void (*func) (void)
  int exec;
} struct Sched_Task_t;

Sched_Task_t tasks[20];
int current_task = 20;

void sched_init(void)
{
  for (x=0; x<20; x++)
    tasks[x].func = 0;
}

int sched_add_task(void (*f)(void), int d, int p)
{
  for(int x=0; x<20; x++)
    if (!Tasks[x].func) 
    {
      Tasks[x].period = p;
      Tasks[x].del = d;
      Tasks[x].exec = 0;
      Tasks[x].func = f;
      return x;
    }
    return -1;
}

void sched_dispatch(void)
{
  for(int x=0; x<20; x++) 
  {
    if((Tasks[x].func) && (Tasks[x].exec)) 
    {
      Tasks[x].exec--;
      Tasks[x].func();
      /* Delete task if one-shot*/
      if(!Tasks[x].period)
        Tasks[x].func = 0;
      return;
    }
  }
}

void sched_schedule(void)
{
  for(x=0; x<20; x++) 
  {
    if (!Tasks[x].func)
    {
      if (Tasks[x].del) 
      {
        Tasks[x].del--;
      } 
      else 
      {
        /* Schedule Task */
        Tasks[x].exec++;
        Tasks[x].del = Tasks[x].period - 1;
      }
    }
  }
}

void int_handler(void)
{
  disable_interrupts();
  sched_schedule();
  sched_dispatch();
  enable_interrupts();
};
