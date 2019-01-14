const MongoClient = require('mongodb').MongoClient;
const assert = require('assert');

//Connection URL
//const url = 'mongodb://localhost:27017'; // ok
//const url = 'mongodb://mongors1n1,mongors1n2,mongors1n2/?replicaSet=mongors1'; // replica set

const url = 'mongodb://mongos1:27017,mongos2:27017'; // mongod
//const url = 'mongodb://localhost:27020,localhost:27019';

// Database Name
let db;

const dbName = 'testDb';
let message = 'hello world';

//Use connect method to connect to the server
function conectToDo() {
  MongoClient.connect(url, function(err, client) {
    if(err ===  null) {
      message = "Connected successfully to server";
      db = client.db(dbName);
      client.close();
    }
    else{
      message = err;
    }

    console.log(message);
    setTimeout(conectToDo, 2000);
  });
}

console.log("start");
conectToDo();


const express = require('express')
const app = express()

app.get('/', (req, res) => res.send(message))

app.listen(3000, () => console.log('Example app listening on port 3000!'))