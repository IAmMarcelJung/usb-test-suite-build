# USB test suite

Copyright (c) 2019-2021 [Antmicro](https://www.antmicro.com)

This is a [Cocotb](https://github.com/cocotb/cocotb) based USB 1.1 test suite (to be extended to cover higher versions of the standard) for FPGA IP, with testbenches for a variety of open source USB cores. Cocotb enables testing IPs with Python, which makes for a very robust and developer-friendly workflow.

This repository is a top level repo, with libraries used by the project and specific testbenches and cores as submodules.

Documentation for this project is hosted at [Read the Docs](https://usb-test-suite.readthedocs.io/en/latest/index.html).

## Setup

The setup was changed from the purely python based setup with an installation script to a nix-based setup.

### Prerequisites

* [Nix](https://nixos.org/download/) with flakes enabled

### Steps

```
# Clone the repository
git clone https://github.com/antmicro/usb-test-suite-build.git
cd usb-test-suite-build

# Initialize submodules
git submodule update --init --recursive

# Enter the development environment
nix develop
```

## Usage

Use the Makefile in **usb-test-suite-testbenches** folder to choose the IP core and test module.
Currently, we support testing:

* [ValentyUSB](https://github.com/im-tomu/valentyusb)
* [Foboot](https://github.com/im-tomu/foboot)
* [asics-ws usb1_device](https://github.com/www-asics-ws/usb1_device)
* [tnt's USB IP core](https://github.com/smunaut/ice40-playground/tree/master/cores/usb)
* [TinyFPGA-Bootloader](https://github.com/tinyfpga/TinyFPGA-Bootloader)

Newly added:
* [USB_CDC](https://github.com/ulixxe/usb_cdc)

Execute tests by calling:

```
cd usb-test-suite-testbenches
# Execute tests with default values
make sim
```

Make sure to run `make clean` when switching targets. See the README in **usb-test-suite-testbenches** for details.
