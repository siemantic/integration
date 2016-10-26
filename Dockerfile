FROM ubuntu:16.04
RUN rm /bin/sh && ln -s /bin/bash /bin/sh
RUN apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv EA312927
RUN echo "deb http://repo.mongodb.org/apt/ubuntu xenial/mongodb-org/3.2 multiverse" | tee /etc/apt/sources.list.d/mongodb-org-3.2.list
RUN apt-get update
RUN apt-get install -y mongodb-org rabbitmq-server redis-server build-essential wget git python libkrb5-dev vim
ADD https://raw.githubusercontent.com/mongodb/mongo/v3.2/debian/init.d /etc/init.d/mongod
RUN chmod +x /etc/init.d/mongod
WORKDIR /root
RUN wget -qO- https://raw.githubusercontent.com/creationix/nvm/v0.32.1/install.sh | bash
RUN source /root/.nvm/nvm.sh; \
    nvm install v4; \
    nvm alias default v4; \
    nvm use default; \
    npm install pm2 -g;
COPY src/code/ /root/code/
RUN source /root/.nvm/nvm.sh; \
    /root/code/install.sh;
COPY src/config /root/config
COPY src/start_everything.sh /root/start_everything.sh
COPY src/stop_everything.sh /root/stop_everything.sh
EXPOSE 8080
