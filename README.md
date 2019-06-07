# FEUP-SETR

Competitive game using remote-controlled AlphaBot2 kits through a Raspberry Pi

## Build instructions

```bash
# Assumes Python 3 with pip and g++ are pre-installed

pip install Cython
pip install distro
pip install fake-rpi    # Only to run the program on other machines
sudo apt-get install libncurses5-dev libncursesw5-dev
cd src
sh build.sh
```

To start the program running on the AlphaBots, run ```python3 start_alphabot.py```, or ```alphabot.py``` to both build and run

To start the program running on the control RPi, run ```python3 start_control.py```, or ```control.py``` to both build and run

### How to change hostnam on alphabot
Changing hostname to RASP-ALPHABOTX,  X being the number of the player:

Open the /etc/hosts file and change the old hostname to the new one.
Open the /etc/hostname file and change the old hostname to the new one.
sudo hostnamectl set-hostname RASP-ALPHABOTX

If the cloud-init package is installed you also need to edit the cloud.cfg file.
sudo nano /etc/cloud/cloud.cfg 
Search for preserve_hostname and change the value from false to true

sudo dhclient -r

reset computers being used