#!/bin/bash

yum install -y epel-release wget docker
yum install -y zip
yum install -y unzip


# enable docker services
systemctl enable docker.service
systemctl start docker.service

docker pull sathishkumar281995/spring-petclinic

cat > /etc/systemd/system/docker_app_container.service << EOL
[Unit]
Wants=docker.service
After=docker.service

[Service]
RemainAfterExit=yes
ExecStart=/usr/bin/docker run --restart=always  -p 8080:8080  docker.io/sathishkumar281995/spring-petclinic
ExecStop=/usr/bin/docker stop $(docker ps -q --filter ancestor=spring-petclinic)


[Install]
WantedBy=multi-user.target
EOL

# enable docker_app_container service
systemctl enable docker_app_container.service
systemctl start docker_app_container.service

