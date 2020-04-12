#!/usr/bin/env python3
##
# Using https://github.com/rsc-dev/pyamaha
##
from pyamaha import Device, Zone
from argparse import ArgumentParser

exec(open("config.py").read())

if __name__ == "__main__":
    args = ArgumentParser(description='Yamaha Amplifier Remote Control')
    args.add_argument('command', nargs=1, choices=['on', 'standby', 'toggle'])
    args = args.parse_args()
    assert len(args.command) == 1
    cmd = args.command[0]

    dev = Device(device_ip)
    res = dev.request(Zone.set_power('main', cmd))

    print(res.json())
