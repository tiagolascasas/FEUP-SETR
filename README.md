# FEUP-SETR

Competitive game using remote-controlled AlphaBot2 kits through a Raspberry Pi

## Build instructions

```bash
# Assumes python3, pip and g++ pre-installed

pip install Cython
sudo apt-get install libncurses5-dev libncursesw5-dev
cd src
sh build.sh
```

To start the program running on the AlphaBots, run ```python3 start_alphabot.py```

To start the program running on the control RPi, run ```python3 start_control.py```
