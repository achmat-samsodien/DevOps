#!/usr/bin/env python3

'''
Scripts connects to Database, determines length of table via id column
Telephones and email are randomly generated via random and faker package
Faker package allows for random name generation as well should we need to sanitise it
'''

import pymysql
import sys
import random
from barnum import gen_data
from collections import Counter
from faker import Faker

db = pymysql.connect("localhost","root","password","dbname" )
# TODO: make this a sysargv variable
table = sys.argv[1]
cursor = db.cursor()


select = "SELECT id FROM %s;" % table
cursor.execute(select)
data = cursor.fetchall()

listId = []
for d in data:
    tId = d[0]
    listId.append(tId)

# sort list
listId.sort()

# Find range from id length
ranrange = len(listId)

def sqlrun(column, update):
    for i, d in zip(listId, column):
        cursor.execute(update % (table,d,i))

def sqlmpesa(col1, col2, col3, col4, col5, update):
    for i, d, e, f, g, h in zip(listId, col1, col2, col3, col4, col5):
        cursor.execute(update %(table,d,e,f,g,h,i))

# alias faker package
fake = Faker()
#fakemail = [fake.email() for _ in range(ranrange)]
fakename = [fake.name() for _ in range(ranrange)]
fakemail = [gen_data.create_email() for _ in range(ranrange)]


# generate 12 digit numberx§
phone = [random.randint(0,999999999999) for _ in range(ranrange)]
phonere = "UPDATE %s SET phone='%s' WHERE id = '%s';"
emailre = "UPDATE %s SET email='%s' WHERE id = '%s';"
namere = "UPDATE %s SET name='%s' WHERE id = '%s';"
mpesatb = "UPDATE %s SET receipt_no='%s', details='%s', other_party_info='%s', ac_no='%s', operator='%s' WHERE id = '%s';"
altad = "ALTER TABLE `admins` AUTO_INCREMENT = 0"
altch = "ALTER TABLE `admins` AUTO_INCREMENT = 1"
altu = "ALTER TABLE `admins` AUTO_INCREMENT = 2"
adadmin = "INSERT INTO `admins` (`id`,`name`, `email`, `phone`, `password`, `account_id`) VALUES (%s, %s, %s, %s, %s, %s) ON DUPLICATE KEY UPDATE `id`=`id`+100"
adadm = "INSERT INTO `admins` (`id`,`name`, `email`, `phone`, `password`, `account_id`) VALUES (%s, %s, %s, %s, %s, %s)"


#Check if there is there uniques TO BE REMOVED
#print ([k for k,v in Counter(fakemail).items() if v>1])

if table == "mpesa":
    sqlmpesa(phone,fakename,fakename,phone,fakename,mpesatb)
elif table == "admins":
    sqlrun(phone, phonere)
    sqlrun(fakemail, emailre)
    sqlrun(fakename, namere)
    cursor.execute(altad)
    cursor.execute(adadmin, ('1','Admin', 'ima@admin.com', '+254 734 390111', '1234', '1'))
    cursor.execute(adadm, ('1','Admin', 'ima@admin.com', '+254 734 390111', '1234', '1'))
    cursor.execute(altch)
    cursor.execute(adadmin, ('2','Champ', 'champ@admin.com', '+254 734 390112', '1234', '1'))
    cursor.execute(adadm, ('2','Champ', 'champ@admin.com', '+254 734 390112', '1234', '1'))
    cursor.execute(altu)
    cursor.execute(adadmin, ('3','User', 'user@admin.com', '+254 734 390113', '1234', '1'))
    cursor.execute(adadm, ('3','User', 'user@admin.com', '+254 734 390113', '1234', '1'))
else:
    sqlrun(phone, phonere)
    sqlrun(fakemail, emailre)
    sqlrun(fakename, namere)

# commit statement
db.commit()

# disconnect from server
db.close()
