mvn clean install

docker login http://registry.hub.docker.com

docker build -t giftingapp-shopping-service .

docker tag giftingapp-shopping-service:latest sathishkumar281995/giftingapp-shopping-service:latest

docker push sathishkumar281995/giftingapp-shopping-service:latest