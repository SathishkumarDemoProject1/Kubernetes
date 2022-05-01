mvn clean install

docker login http://registry.hub.docker.com -u $USER_NAME -p $PASSWORD

docker build ./ -t giftingapp-merchant-service/merchant-service:0.0.1

docker push giftingapp-merchant-service/merchant-service:0.0.1
