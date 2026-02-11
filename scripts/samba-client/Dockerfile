FROM alpine

RUN apk add --update \
    bash \
    samba-common-tools \
    samba-client \
    cifs-utils \
    && rm -rf /var/cache/apk/*

RUN mkdir /samba
RUN mount -t cifs -o domain=WORKGROUP,username=user,password=password  //192.168.10.123/Pictures /samba