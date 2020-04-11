#!/usr/bin/env python3
##
# Using https://github.com/supersaiyanmode/PyWebOSTV
##
from pywebostv.connection import WebOSClient
from pywebostv.controls import SystemControl, ApplicationControl, SourceControl
from sys import exit
from wakeonlan import send_magic_packet
from argparse import ArgumentParser

exec(open("config.py").read())

if __name__ == "__main__":
    args = ArgumentParser(description='LG WebOS TV Remote Control')
    args.add_argument('command', nargs=1, choices=['register', 'test', 'on', 'off', 'forceoff'])
    args = args.parse_args()
    assert len(args.command) == 1
    cmd = args.command[0]

    if cmd == 'on':
        send_magic_packet(tv_mac)

    client = WebOSClient(tv_ip)
    client.connect()

    def is_me_using():
        app = ApplicationControl(client)
        app_id = app.get_current()
        return app_id == "com.webos.app.hdmi1"

    if cmd == 'register':
        for status in client.register(store):
            if status == WebOSClient.PROMPTED:
                print("Please accept the connect on the TV!")
            if status == WebOSClient.REGISTERED:
                print("\nRegistration successful!\nstore = " + str(store))
                exit(0)
    else:
        for status in client.register(store):
            assert status == WebOSClient.REGISTERED

    if cmd == 'test':
        c = SystemControl(client)
        c.notify("test")
    elif cmd == 'on' and not is_me_using():
        c = SystemControl(client)
        source_control = SourceControl(client)
        sources = source_control.list_sources()
        hdmi_source = next((s for s in sources if s.label == "HDMI1"), None)
        if hdmi_source:
            c.notify("Setting " + str(hdmi_source))
            source_control.set_source(hdmi_source)
    elif (cmd == 'forceoff') or (cmd == 'off' and is_me_using()):
        c = SystemControl(client)
        c.notify("Bye-bye TV!")
        c.power_off()
