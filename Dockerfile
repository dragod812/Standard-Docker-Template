FROM ubuntu:17.10
COPY . /app

#RUN apt-get update && apt-get install -y \
#python-software-properties \
#software-properties-common

#RUN add-apt-repository \
#ppa:webupd8team/java

#installing the required software
RUN apt-get update && apt-get install -y \
openjdk-8-jdk \
debconf-utils \
maven \
eclipse \
git-all \
build-essential \
wget 

#set rootpassword for mysql as "rootpw"
RUN export DEBIAN_FRONTEND="noninteractive"
RUN echo "mysql-server mysql-server/root_password password rootpw" | debconf-set-selections 
RUN echo "mysql-server mysql-server/root_password_again password rootpw" | debconf-set-selections 
#install mysql
RUN apt-get install -y -q mysql-server
#setting up tomcat server
RUN cd /opt && wget http://archive.apache.org/dist/tomcat/tomcat-9/v9.0.0.M11/bin/apache-tomcat-9.0.0.M11.tar.gz \
&& tar xzf apache-tomcat-9.0.0.M11.tar.gz && mv apache-tomcat-9.0.0.M11 tomcat9
RUN echo "export JAVA_HOME="/usr/lib/jvm/java-8-openjdk-amd64"" >> /etc/environment \
&& echo "export JRE_HOME="/usr/lib/jvm/java-8-openjdk-amd64/jre"" >> /etc/environment  \
&& echo "export CATALINA_HOME="/opt/tomcat9"" >> /etc/environment 
RUN export CATALINA_HOME="/opt/tomcat9" 

RUN cp app/tomcat-users.xml $CATALINA_HOME/conf

CMD eclipse
