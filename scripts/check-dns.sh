#!/bin/bash

if [ -z $(pidof named) ]; then
    echo "DNS is stopped!"
    systemctl start bind9 
    echo date '+%Y-%m-%d %H:%M:%S' >> "/tmp/check-dns.log" 
else
    echo "DNS is running!"
fi