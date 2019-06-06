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
