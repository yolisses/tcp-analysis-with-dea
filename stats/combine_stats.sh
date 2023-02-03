stats=("fractal" "time_taken_for_tests" "time_per_req" "transfer_rate" "hurst" "req_per_sec")

header="dmu,"
for stat in ${stats[@]}; do
    header=$header$stat,
done
header=${header::-1} # remove last comma
echo $header >stats.csv

for file in fractal/*; do
    dmu=${file#fractal/fractal_}
    dmu=${dmu%.txt}

    line=$dmu,
    for stat in ${stats[@]}; do
        value=$(cat ./$stat/${stat}_$dmu.txt)
        line=$line$value,
    done
    line=${line::-1} # remove last comma
    echo $line >>stats.csv
done
