docker-elastic-mongo
====================

Docker image for MongoDB and ElasticSearch with river plugin.

## Build and run docker image
```
$ docker build -t=elastic-mongo .
$ docker run -p 9200:9200 -p 27017:27017 elastic-mongo
```
## Initiate replication set
```
$ echo 'rs.initiate()' | mongo
```
## Create an ElasticSearch index
```
$ curl -XPUT 'http://localhost:9200/_river/mongodb/_meta' -d '{ "type": "mongodb", "mongodb": { "db": "testmongo", "collection": "person" }, "index": { "name": "mongoindex", "type": "person" } }'
```
## Query from ElasticSearch in order to check the result
```
$ curl -XGET 'localhost:9200/mongoindex/_search?pretty=true'
```





