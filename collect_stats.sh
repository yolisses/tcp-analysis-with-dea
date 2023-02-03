#/bin/bash
cat $1 | grep Requests\ per\ second > req_per_sec
awk '{print $4}' req_per_sec > req_per_sec_$1
rm req_per_sec
cat $1 | grep concurrent\ request > time_per_req
awk '{print $4}' time_per_req > time_per_req_$1
rm time_per_req
cat $1 | grep Transfer\ rate > transfer_rate
awk '{print $3}' transfer_rate > transfer_rate_$1
rm transfer_rate
cat $1 | grep tests > time_taken
awk '{print $5}' time_taken > time_taken_for_tests_$1
rm time_taken
mkdir stats
mv req_per_sec_$1 stats
mv time_per_req_$1 stats
mv transfer_rate_$1 stats
mv time_taken_for_tests_$1 stats