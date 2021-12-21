mvn clean install

docker login http://registry.hub.docker.com

docker build -t giftingapp-merchant-service .

docker tag giftingapp-merchant-service:latest XXXXXXXXXX/giftingapp-merchant-service:latest

docker push XXXXXXXXXX/giftingapp-merchant-service:latest