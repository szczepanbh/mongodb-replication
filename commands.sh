#!/bin/bash
echo --- config servers replica ---
docker exec -it mongocfg1 bash -c "echo 'rs.initiate({_id: \"mongors1conf\",configsvr: true, members: [{ _id : 0, host : \"mongocfg1\" },{ _id : 1, host : \"mongocfg2\" }, { _id : 2, host : \"mongocfg3\" }]})' | mongo"
#docker exec -it mongocfg1 bash -c "echo 'rs.status()' | mongo"

sleep 5[s]
echo --- shard replica set ---
docker exec -it mongors1n1 bash -c "echo 'rs.initiate({_id : \"mongors1\", members: [{ _id : 0, host : \"mongors1n1\" },{ _id : 1, host : \"mongors1n2\" },{ _id : 2, host : \"mongors1n3\" }]})' | mongo"
docker exec -it mongors2n1 bash -c "echo 'rs.initiate({_id : \"mongors2\", members: [{ _id : 0, host : \"mongors2n1\" },{ _id : 1, host : \"mongors2n2\" },{ _id : 2, host : \"mongors2n3\" }]})' | mongo"
#docker exec -it mongors1n1 bash -c "echo 'rs.status()' | mongo"

sleep 20[s]
echo --- introduce our shard to the routers ---
# with the name of the replica set MongoDB will discover all other members of the replica set.
docker exec -it mongos1 bash -c "echo 'sh.addShard(\"mongors1/mongors1n1\")' | mongo "
docker exec -it mongos1 bash -c "echo 'sh.addShard(\"mongors2/mongors2n1\")' | mongo "

docker exec -it mongos2 bash -c "echo 'sh.addShard(\"mongors1/mongors1n1\")' | mongo "
docker exec -it mongos2 bash -c "echo 'sh.addShard(\"mongors2/mongors2n1\")' | mongo "
#docker exec -it mongos1 bash -c "echo 'sh.status()' | mongo "

sleep 2[s]
docker exec -it mongos1 bash -c "echo 'sh.enableSharding(\"testDb\")' | mongo "
docker exec -it mongos2 bash -c "echo 'sh.enableSharding(\"testDb\")' | mongo "

sleep 2[s]
docker exec -it mongos1 bash -c "echo 'sh.shardCollection(\"testDb.testCollection\", {_id : \"hashed\"})' | mongo "
docker exec -it mongos2 bash -c "echo 'sh.shardCollection(\"testDb.testCollection\", {_id : \"hashed\"})' | mongo "

sleep 2[s]
#docker exec -it mongos1 bash -c "echo 'use testDb' | mongo"
#docker exec -it mongos1 bash -c "echo 'use testDb && for(var i=0; i<1000; i++){ db.testCollection.insert({name:i}) }' | mongo"

