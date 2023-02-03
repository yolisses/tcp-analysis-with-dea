for filename in *.txt; do
    ./collect_stats.sh $filename
done

for filename in *.csv; do
    ./trata_csv.sh $filename
done