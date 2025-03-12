#!/bin/bash

for service in $(systemctl --user --no-pager --no-legend --type=service --state=running list-units | awk '{print $1}'); do
    echo "Service: $service"
    systemctl --user show -p MainPID $service | awk -F= '{print $2}' | xargs -r ps -fp
done
