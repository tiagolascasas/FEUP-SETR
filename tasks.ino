void task1(void)
{
  led_turn_on(0)
}

void task2(void)
{
  led_turn_on(1)
}

void task3(void)
{
  led_turn_on(2)
}

void task4(void)
{
  led_turn_on(3)
}

void led_turn_on(int led)
{
    digitalWrite(LED[0], led == 0 ? LOW : HIGH);
    digitalWrite(LED[1], led == 1 ? LOW : HIGH);
    digitalWrite(LED[2], led == 2 ? LOW : HIGH);
    digitalWrite(LED[3], led == 3 ? LOW : HIGH);
}
