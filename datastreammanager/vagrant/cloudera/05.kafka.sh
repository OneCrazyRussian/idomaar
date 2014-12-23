#!/bin/sh -Eux

cd /tmp
wget -nv -O kafka.tgz http://mirror.nohup.it/apache/kafka/0.8.1.1/kafka_2.10-0.8.1.1.tgz

tar -xvf kafka.tgz
mkdir -p /opt/apache
mv kafka_2.10-0.8.1.1 /opt/apache
cd /opt/apache
ln -s /opt/apache/kafka_2.10-0.8.1.1 kafka
mkdir /var/log/kafka

useradd kafka
chown kafka:kafka /var/log/kafka

IP=$(ifconfig  | grep 'inet addr:'| grep 168 | grep 192|cut -d: -f2 | awk '{ print $1}')
#sed 's/broker.id=0/'broker.id=$1'/' /opt/apache/kafka/config/server.properties > /tmp/prop1.tmp
sed 's/log.dirs=\/tmp\/kafka-logs/'log.dirs=\\/var\\/log\\/kafka'/' /opt/apache/kafka/config/server.properties > /tmp/prop1.tmp
sed 's/#advertised.host.name=<hostname routable by clients>/'advertised.host.name=$IP'/' /tmp/prop1.tmp > /tmp/prop2.tmp
sed 's/#host.name=localhost/'host.name=$IP'/' /tmp/prop2.tmp  > /opt/apache/kafka/config/server-vagrant.properties


cp /vagrant/vagrant/cloudera/init.d/kafka /etc/init.d/
chmod +x /etc/init.d/kafka

service kafka start
update-rc.d kafka defaults
