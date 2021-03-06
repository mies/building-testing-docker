echo "removing containers"
sudo docker ps -a | tail -n +2 | awk '{print $1}' | xargs sudo docker kill
sudo docker ps -a | tail -n +2 | awk '{print $1}' | xargs sudo docker rm

echo "---"
echo "setting up master"
echo "---"
export MASTER_ID=$(sudo docker run -p 29015:29015 -p 28015:28015 -d mies/rethinkdb rethinkdb --bind all)
export MASTER_IP=$(sudo docker inspect $MASTER_ID | grep IPAddress | cut -d '"' -f 4)
export MASTER_CLUSTER_PORT=$(sudo docker port $MASTER_ID 29015)
export MASTER_PORT=$(sudo docker port $MASTER_ID 28015)

echo "---"
echo "setting up first slave"
echo "---"
export SLAVE1_ID=$(sudo docker run -p 29015 -p 28015 -d mies/rethinkdb rethinkdb --join $MASTER_IP:$MASTER_CLUSTER_PORT --bind all)
export SLAVE1_PORT=$(sudo docker port $SLAVE1_ID 28015)
export SLAVE1_IP=$(sudo docker inspect $SLAVE1_ID | grep IPAddress | cut -d '"' -f 4)

echo "---"
echo "setting up second slave"
echo "---"
export SLAVE2_ID=$(sudo docker run -p 49235:29015 -p 49236:28015 -d mies/rethinkdb rethinkdb --join $MASTER_IP:$MASTER_CLUSTER_PORT --bind all)
export SLAVE2_PORT=$(sudo docker port $SLAVE2_ID 28015)
export SLAVE2_IP=$(sudo docker inspect $SLAVE2_ID | grep IPAddress | cut -d '"' -f 4)