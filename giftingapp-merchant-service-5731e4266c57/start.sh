mvn clean install

docker login http://registry.hub.docker.com -u $username -p $password

docker build ./ -t giftingapp-merchant-service/merchant-service:0.0.1

docker push giftingapp-merchant-service/merchant-service:0.0.1
