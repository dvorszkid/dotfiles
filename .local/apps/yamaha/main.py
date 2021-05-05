#!/usr/bin/env python3
##
# Using https://github.com/rsc-dev/pyamaha
##
from pyamaha import Device, Zone
from argparse import ArgumentParser

exec(open("config.py").read())

if __name__ == "__main__":
    args = ArgumentParser(description='Yamaha Amplifier Remote Control')
    args.add_argument('command', nargs=1, choices=[
        'status',
        'on', 'standby', 'toggle',
        'volume_up', 'volume_down'])
    args = args.parse_args()
    assert len(args.command) == 1
    cmd = args.command[0]

    dev = Device(device_ip)

    if cmd == 'status':
        res = dev.request(Zone.get_status('main'));
    elif cmd.startswith('volume_'):
        status = dev.request(Zone.get_status('main')).json()
        volume_step = int(status['max_volume']*0.05)
        if cmd.endswith('down'):
            volume_step *= -1
        res = dev.request(Zone.set_volume('main', status['volume'] + volume_step, 1))
    else:
        res = dev.request(Zone.set_power('main', cmd))

    print(res.json())
