#!/usr/bin/env python3

import os
import sys

user = sys.argv[1]


if user == "dev1":
    os.system('sudo -u dev1 /usr/bin/touch /home/dev1/testFile')
    print(user + " " + "can write to directory ")
    os.system('sudo -u dev1 /usr/bin/touch /home/dev2/testFile')
elif user == "dev2":
    os.system('sudo -u dev2 /usr/bin/touch /home/dev2/testFile')
    print(user + " " + "can write to directory ")
    os.system('sudo -u dev2 /usr/bin/touch /home/dev1/testFile')
elif user == "dev3":
    os.system('sudo -u dev3 /usr/bin/touch /home/dev3/testFile')
    print(user + " " + "can write to directory ")
    os.system('sudo -u dev3 /usr/bin/touch /home/dev1/testFile')

exit()