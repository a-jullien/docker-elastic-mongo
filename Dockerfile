# Version: 0.0.1

FROM ubuntu:14.04
MAINTAINER Antoine Jullien "antoine.jullien@gmail.com"

# Import MongoDB public key and append to sources list
RUN apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv 7F0CEB10
RUN echo 'deb http://downloads-distro.mongodb.org/repo/ubuntu-upstart dist 10gen' | tee /etc/apt/sources.list.d/10gen.list

# Update and install tools, MongoDB and ElasticSearch
RUN apt-get update
RUN apt-get install -y -q wget dpkg unzip curl supervisor openjdk-7-jre
RUN apt-get install mongodb-org -y 

# Elastic search - download archive
RUN wget https://download.elasticsearch.org/elasticsearch/elasticsearch/elasticsearch-1.0.3.zip
# Elastic search - installation
RUN unzip elasticsearch-1.0.3.zip -d /opt/
  
# Create the MongoDB data directory
RUN mkdir -p /data/db
# Add mongoDB default configuration
ADD resources/mongodb.conf /data/mongodb.conf
# Supervisor configuration
RUN mkdir -p /var/log/supervisor
ADD resources/supervisord.conf /etc/supervisor/conf.d/supervisord.conf
# Elastic search - Global configuration
ADD resources/elasticsearch.yml /opt/elasticsearch-1.0.3/config/elasticsearch.yml
# plugin river for mongodb
RUN /opt/elasticsearch-1.0.3/bin/plugin --install com.github.richardwilly98.elasticsearch/elasticsearch-river-mongodb/2.0.0

ADD resources/mongo_rs_initiate.sh /opt/mongo_rs_initiate.sh
RUN chmod +x /opt/mongo_rs_initiate.sh
# Expose mongodb default port 27017 from the container
EXPOSE 27017
# Expose Elastic search ports - HTTP
EXPOSE 9200
# Expose Elastic search ports - Transport
EXPOSE 9300
# start supervisord
CMD ["/usr/bin/supervisord"]
