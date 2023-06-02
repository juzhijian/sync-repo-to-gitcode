FROM alpine:latest

RUN apk update && apk upgrade &&\
  apk add --no-cache git p7zip p7zip-plugins openssh-client && \
  echo "StrictHostKeyChecking no" >> /etc/ssh/ssh_config

ADD *.sh /

ENTRYPOINT ["/entrypoint.sh"]
