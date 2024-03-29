import distro

GPIO = None

d = distro.linux_distribution(full_distribution_name=False)[0]

if d == 'raspbian':
    import RPi.GPIO as GPIO
else:
    import fake_rpi
    GPIO = fake_rpi.RPi.GPIO
    fake_rpi.toggle_print(False)


class AlphaBot2(object):
    
    def __init__(self,ain1=12,ain2=13,ena=6,bin1=20,bin2=21,enb=26):
        self.AIN1 = ain1
        self.AIN2 = ain2
        self.BIN1 = bin1
        self.BIN2 = bin2
        self.ENA = ena
        self.ENB = enb
        self.BUZ = 4
        self.CTR = 7
        self.A = 8
        self.B = 9
        self.C = 10
        self.D = 11
        self.DR = 16
        self.DL = 19
        self.PA  = 50
        self.PB  = 50
        self.ROTATE_VELOCITY= 22

        GPIO.setmode(GPIO.BCM)
        GPIO.setwarnings(False)
        GPIO.setup(self.AIN1,GPIO.OUT)
        GPIO.setup(self.AIN2,GPIO.OUT)
        GPIO.setup(self.BIN1,GPIO.OUT)
        GPIO.setup(self.BIN2,GPIO.OUT)
        GPIO.setup(self.ENA,GPIO.OUT)
        GPIO.setup(self.ENB,GPIO.OUT)
        GPIO.setup(self.BUZ,GPIO.OUT)
        GPIO.setup(self.DR,GPIO.IN,GPIO.PUD_UP)
        GPIO.setup(self.DL,GPIO.IN,GPIO.PUD_UP)

        self.PWMA = GPIO.PWM(self.ENA,500)
        self.PWMB = GPIO.PWM(self.ENB,500)
        self.PWMA.start(self.PA)
        self.PWMB.start(self.PB)
        self.stop()

    def forward(self):
        self.PWMA.ChangeDutyCycle(self.PA)
        self.PWMB.ChangeDutyCycle(self.PB)
        GPIO.output(self.AIN1,GPIO.LOW)
        GPIO.output(self.AIN2,GPIO.HIGH)
        GPIO.output(self.BIN1,GPIO.LOW)
        GPIO.output(self.BIN2,GPIO.HIGH)


    def stop(self):
        self.PWMA.ChangeDutyCycle(0)
        self.PWMB.ChangeDutyCycle(0)
        GPIO.output(self.AIN1,GPIO.LOW)
        GPIO.output(self.AIN2,GPIO.LOW)
        GPIO.output(self.BIN1,GPIO.LOW)
        GPIO.output(self.BIN2,GPIO.LOW)

    def backward(self):
        self.PWMA.ChangeDutyCycle(self.PA)
        self.PWMB.ChangeDutyCycle(self.PB)
        GPIO.output(self.AIN1,GPIO.HIGH)
        GPIO.output(self.AIN2,GPIO.LOW)
        GPIO.output(self.BIN1,GPIO.HIGH)
        GPIO.output(self.BIN2,GPIO.LOW)

        
    def left(self):
        self.PWMA.ChangeDutyCycle(self.ROTATE_VELOCITY)
        self.PWMB.ChangeDutyCycle(self.ROTATE_VELOCITY)
        GPIO.output(self.AIN1,GPIO.HIGH)
        GPIO.output(self.AIN2,GPIO.LOW)
        GPIO.output(self.BIN1,GPIO.LOW)
        GPIO.output(self.BIN2,GPIO.HIGH)


    def right(self):
        self.PWMA.ChangeDutyCycle(self.ROTATE_VELOCITY)
        self.PWMB.ChangeDutyCycle(self.ROTATE_VELOCITY)
        GPIO.output(self.AIN1,GPIO.LOW)
        GPIO.output(self.AIN2,GPIO.HIGH)
        GPIO.output(self.BIN1,GPIO.HIGH)
        GPIO.output(self.BIN2,GPIO.LOW)
        
    def set_PWMA(self,value):
        self.PA = value
        self.PWMA.ChangeDutyCycle(self.PA)

    def set_PWMB(self,value):
        self.PB = value
        self.PWMB.ChangeDutyCycle(self.PB)

    def set_speed(self, value):
         self.set_PWMA(value)
         self.set_PWMB(value)   
        
    def set_motor(self, left, right):
        if((right >= 0) and (right <= 100)):
            GPIO.output(self.AIN1,GPIO.HIGH)
            GPIO.output(self.AIN2,GPIO.LOW)
            self.PWMA.ChangeDutyCycle(right)
        elif((right < 0) and (right >= -100)):
            GPIO.output(self.AIN1,GPIO.LOW)
            GPIO.output(self.AIN2,GPIO.HIGH)
            self.PWMA.ChangeDutyCycle(0 - right)
        if((left >= 0) and (left <= 100)):
            GPIO.output(self.BIN1,GPIO.HIGH)
            GPIO.output(self.BIN2,GPIO.LOW)
            self.PWMB.ChangeDutyCycle(left)
        elif((left < 0) and (left >= -100)):
            GPIO.output(self.BIN1,GPIO.LOW)
            GPIO.output(self.BIN2,GPIO.HIGH)
            self.PWMB.ChangeDutyCycle(0 - left)

    def set_beep(self, on):
        if on:
            GPIO.output(self.BUZ, GPIO.HIGH)
        else:
            GPIO.output(self.BUZ, GPIO.LOW)

    def detect_collisions(self):
        DR_status = GPIO.input(self.DR)
        DL_status = GPIO.input(self.DL)
        return (DL_status == 0) or (DR_status == 0)
    
    def cleanup(self):
        GPIO.cleanup()