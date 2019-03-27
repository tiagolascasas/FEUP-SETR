/* Declare everything here because we are pretending to be
electrotechnicians who don't know what a header file is */

/* Arduino */
const byte LED[] = {13,12,11,10}; /* Define the DIO pin numbers for each LED */

/* Scheduler */
typedef struct
{
	int period;
	int del;
	void (*func) (void);
	int exec;
} Sched_Task_t;

Sched_Task_t tasks[20];
int current_task = 20;

void sched_init(void);
int sched_add_task(void (*f)(void), int d, int p);
void sched_dispatch(void);
void int_handler(void);
void sched_schedule(void);
void disable_interrupts(void);
void enable_interrupts(void);

/* Tasks */
void task1(void);
void task2(void);
void task3(void);
void task4(void);
void led_turn_on(int led);

/*---------*/
/* Arduino */
/*---------*/
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
	sched_dispatch();
}

/*----------*/
/* Sheduler */
/*----------*/
void sched_init(void)
{
	for (int x=0; x<20; x++)
		tasks[x].func = 0;
}

int sched_add_task(void (*f)(void), int d, int p)
{
	for(int x=0; x<20; x++)
	{
		if (!tasks[x].func)
		{
			tasks[x].period = p;
			tasks[x].del = d;
			tasks[x].exec = 0;
			tasks[x].func = f;
			return x;
		}
		return -1;
	}
}

void sched_dispatch(void)
{
	for(int x=0; x<20; x++)
	{
		if((tasks[x].func) && (tasks[x].exec))
		{
			tasks[x].exec--;
			tasks[x].func();
/* Delete task if one-shot*/
			if(!tasks[x].period)
				tasks[x].func = 0;
			return;
		}
	}
}

void sched_schedule(void)
{
	for(int x=0; x<20; x++)
	{
		if (!tasks[x].func)
		{
			if (tasks[x].del)
			{
				tasks[x].del--;
			}
			else
			{
/* Schedule Task */
				tasks[x].exec++;
				tasks[x].del = tasks[x].period - 1;
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

/*-------*/
/* Tasks */
/*-------*/
void task1(void)
{
	led_turn_on(0);
}

void task2(void)
{
	led_turn_on(1);
}

void task3(void)
{
	led_turn_on(2);
}

void task4(void)
{
	led_turn_on(3);
}

void led_turn_on(int led)
{
	digitalWrite(LED[led] == LOW ? HIGH : LOW);
}
