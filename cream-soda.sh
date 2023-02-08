run_traffic() {
	clients=(100 500 1000)
	requests=(2000 10000 20000)
	for index in ${!clients[@]}; do
		s=$((index + 1))
		c=${clients[$index]}
		n=${requests[$index]}
		filename="cubic_${TCP_STRATEGY}_${SERVER_TYPE}_escalonamento$s"
		command="ssh $HOST_SSH ab -c $c -n $n -e $filename.csv $SERVER_URL >${filename}_out.txt"
		echo $command
		$command
	done
}

update_strategy() {
	export TCP_STRATEGY=$1
	echo "setting TCP congestion control algorithm to $TCP_STRATEGY"
	echo $TCP_STRATEGY >/proc/sys/net/ipv4/tcp_congestion_control
	cat /proc/sys/net/ipv4/tcp_congestion_control
}

update_server() {
	export SERVER_TYPE=$1
	if [ "$SERVER_TYPE" = "apache2" ]; then
		echo "changing to apache2"
		docker exec $DOCKER_ID service nginx stop
		docker exec $DOCKER_ID service apache2 start
	elif [ "$SERVER_TYPE" = "nginx" ]; then
		echo "changing to nginx"
		docker exec $DOCKER_ID service apache2 stop
		docker exec $DOCKER_ID service nginx start
	else
		echo "error using SERVER_TYPE value '$SERVER_TYPE'"
		exit 1
	fi
	docker exec $DOCKER_ID service apache2 status | cat
	docker exec $DOCKER_ID service nginx status | cat
}

servers=("nginx" "apache2")
strategies=("cubic" "bic" "westwood" "htcp" "hybla" "vegas" "nv" "scalable" "lp" "veno" "yeah" "illinois" "dctcp" "cdg" "bbr")

DOCKER_ID=3baffa361132
HOST_SSH="djr@192.168.1.210"
SERVER_URL="https://www.labredes.br/index.html"

echo "running with:"
echo "HOST_SSH=$HOST_SSH"
echo "DOCKER_ID=$DOCKER_ID"
echo "SERVER_URL=$SERVER_URL"

docker start $DOCKER_ID

for server in ${servers[@]}; do
	update_server $server
	for strategy in ${strategies[@]}; do
		update_strategy $strategy
		run_traffic
	done
done
