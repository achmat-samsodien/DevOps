#!/usr/bin/env python3


#Version 1
# My experience with unittest module is limited, so going with what I know
# Script not scalable for now but my schedule is bit full and I can't spend more time on this right now


import os
import sys
import errno

#run with user input
user = sys.argv[1]
#temp file to test write access
testFile = 'sampleFile'

if user == "dev1":
    try:
        #assume user
        os.setuid(1002)
        #write tempFile to user directory
        with open(os.path.join('/home/dev1/',testFile), 'wb') as temp_file:
            temp_file.write(buff)
        print(user + " " + "can write to directory ")
        #write to another user directory
        with open(os.path.join('/home/dev2/',testFile), 'wb') as temp_file:
            temp_file.write(buff)
        #throw exception if user cannot write to directory
    except OSError as e:
        if e.errno == errno.EPERM:
            print("Error: You do not have permission to write to here")
        pass
elif user == "dev2":
    try:
        os.setuid(1003)
        with open(os.path.join('/home/dev1/', testFile), 'wb') as temp_file:
            temp_file.write(buff)
        print(user + " " + "can write to directory ")
        with open(os.path.join('/home/dev2/', testFile), 'wb') as temp_file:
            temp_file.write(buff)
    except OSError as e:
        if e.errno == errno.EPERM:
            print("Error: You do not have permission to write to here")
        pass
elif user == "dev3":
    try:
        os.setuid(1004)
        with open(os.path.join('/home/dev1/', testFile), 'wb') as temp_file:
            temp_file.write(buff)
        print(user + " " + "can write to directory ")
        with open(os.path.join('/home/dev2/', testFile), 'wb') as temp_file:
            temp_file.write(buff)
    except OSError as e:
        if e.errno == errno.EPERM:
            print("Error: You do not have permission to write to here")
        pass
exit()