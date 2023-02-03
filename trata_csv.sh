#/bin/bash
sed -i 1d $1
cat $1 | cut -d ',' -f2 > stats/$1_timeseries.txt
