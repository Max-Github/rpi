#!/bin/bash

echo 'RpiTimeLapse'
echo 'Enter number of minutes (1 pic/min):'

read NumberOfImages #1440 # 1440 Minutes in a day.

echo "Total Number Of Images $NumberOfImages."

Location="./timelapse"
Date=$(date "+%b_%d_%Y_%H.%M.%S") 

for i in $(seq -f "%06g"  0 1 $(expr $NumberOfImages - 1));
do
        FileName="$Location/Image-$Date-$i.jpg"
        raspistill -rot 90 -q 75 -e jpg -o $FileName
        echo "$FileName - saved."
        sleep 54
done

cd $Location

ls -tr *.jpg > stills.txt

mencoder -nosound -ovc lavc -lavcopts vcodec=mpeg4:aspect=16/9:vbitrate=8000000 -vf scale=1920:1080 -o timelapse_$Date.avi -mf type=jpeg:fps=24 mf://@stills.txt

exit 0
