#!/bin/bash

#D March 2018

#This Script will change a standardized m3u file to the v9s basic format for IPTV

# It will create a few temp files in your home directory (temporarily) as well as a final tvlist.txt that you can put onto usb and upload to your V9S
# I am not a programmer hence the reason why this is written in bash and there may be longwinded ways of getting the desired list. If you know a better way - please contribute back.

# change to home directory
cd ~/
# get my latest list from Github

wget https://raw.githubusercontent.com/GetToDaChoppaARRRRG/solovox/master/Playlists/Chopper.m3u8

#################### Not used but may be useful if you want to manipulate this script ################################

# Useful Commands for manipulation

### to show all channel names
### cut -sd',' -f2 Chopper.m3u8

### to get group name per line removing bloated tag
### cut -sd',' -f1 Chopper.m3u8 |sed 's|"||g;s|#EXTINF:-0 group-title=||g'

### to remove blank lines and title m3u for ease
### sed '/EXTM3U/d;/^$/d' Chopper.m3u8

#sed '/EXTM3U/d;/^$/d' Chopper.m3u8 >> test.txt
#awk 'NR%2{printf "%s ",$0;next;}1' test.txt >>test2.txt | sed 's|"||g;s|#EXTINF:-0 group-title=||g'

###lines for clearing up formats
### removes quotes, ext inf, ext title, spaces change to underscore,removes commas, 
#######################################################################################################################

#### Create a list with no spaces and only the info we want

cat Chopper.m3u8 | sed 's|"||g;s|#EXTINF:-0 group-title=||g;/EXTM3U/d;/^$/d;s| |_|g;s|,| |g;' >>templist1.txt

#### Move the address line to the above line

awk 'NR%2{printf "%s ",$0;next;}1' templist1.txt >>templist2.txt

#### Now create a tvlist.txt formatted for V9S ###

cat templist2.txt | while read line
do
group=`echo $line | awk '{print $1}'`
name=`echo $line | awk '{print $2}'`
address=`echo $line | awk '{print $3}'`
echo $name $address "$"$group"$" >> tvlist.txt
done

rm templist1.txt templist2.txt Chopper.m3u8

exit
