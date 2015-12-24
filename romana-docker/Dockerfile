FROM ubuntu
MAINTAINER stas@paninetworks.com

RUN apt-get update && \
    apt-get install -y git screen python python-pip  software-properties-common python-dev

RUN add-apt-repository ppa:ansible/ansible  && \
    apt-get update && \
    pip install ansible boto awscli

RUN mkdir -p /root/.ssh && \
    echo 'Host *' > /root/.ssh/config && \
    echo 'StrictHostKeyChecking no' >> /root/.ssh/config

WORKDIR /root/
ENV USER root

COPY ./run.sh /root/run.sh
ENTRYPOINT ["/root/run.sh"]
