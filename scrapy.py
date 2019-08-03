#!/usr/bin/env python3

# -*- coding: utf-8 -*-

#Import lib that makes HTML and XML extraction easy
from bs4 import BeautifulSoup
import requests
import pymysql

# DB Variables
db = pymysql.connect("localhost","root","password","vehicles" )
cursor = db.cursor()
brandTable = "CREATE TABLE %s (model VARCHAR(255), year VARCHAR(255), url TEXT)"
carRecord = "INSERT INTO `models` (`brand`,`model`,`year`,`url`) VALUES (%s, %s, %s, %s)"

#Get URL
r  = requests.get("http://www.vehiclepartsdatabase.com/vehicles/allprivateroadvehicles/")

# Read contents into variable

data = r.text

# Soupify the data, explicitly specified lxml, got a warning when parsing data without it
soup = BeautifulSoup(data,"lxml")

modelBrandList = []

# Get all available models

for div in soup.find_all('div', attrs={'class':'grid-2 s-grid-whole'}):
   a = div.find_all('a')[0]
   model = {}
   model['name'] = (a.text.strip().encode("utf-8").lower())
   model['url'] = a.attrs['href'].encode("utf-8")
   modelBrandList.append(model)

modelBrandList.pop(29)

print (modelBrandList)

# Traverse links and grab data

for url in modelBrandList:

   carBrand = url["name"]

   url = url["url"].decode("utf-8")

   rModel = requests.get("http://www.vehiclepartsdatabase.com" + url)

   mData = rModel.text

   mSoup = BeautifulSoup(mData,"lxml")

   carList = []
   carUrl = []

   for div in mSoup.find_all('div', attrs={'class':'grid-half equalise left'}):
       a = div.find_all('a')[0]
       carModel = a.text.strip()
       carList.append(carModel)
       carUrl.append(a.attrs['href'])

   carYear = []

   for year in mSoup.find_all('div', attrs={'class':'grid-half equalise right'}):
       yearModel = year.text.strip()
       carYear.append(yearModel)

   for c, y,d in zip(carList, carYear, carUrl):
       cursor.execute(carRecord,(carBrand, c, y, d))

   #commit statement
   db.commit()

#disconnect from server
db.close()