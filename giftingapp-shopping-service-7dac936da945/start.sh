mvn clean install

docker login http://registry.hub.docker.com

docker build -t giftingapp-shopping-service .

docker tag giftingapp-shopping-service:latest XXXXXXXXXX/giftingapp-shopping-service:latest

docker push XXXXXXXXXX/giftingapp-shopping-service:latest