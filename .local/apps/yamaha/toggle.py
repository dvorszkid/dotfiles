#!/usr/bin/env python3
##
# Using https://github.com/rsc-dev/pyamaha
##
from pyamaha import Device, Zone

exec(open("config.py").read())

dev = Device(device_ip)
res = dev.request(Zone.set_power('main', 'toggle'))

print(res.json())
