/* Define the DIO pin numbers for each LED */
const byte LED[] = {13,12,11,10};

void setup() 
{
  pinMode(LED[0], OUTPUT);
  pinMode(LED[1], OUTPUT);
  pinMode(LED[2], OUTPUT);
  pinMode(LED[3], OUTPUT);
  
  shed_init();

  sched_add_task(task1, 0, 2);
  sched_add_task(task2, 0, 4);
  sched_add_task(task3, 0, 6);
  sched_add_task(task4, 0, 8);
}

void loop() 
{
  sched_dispatch()
}
