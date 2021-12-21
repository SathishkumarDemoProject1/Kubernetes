mvn clean install

docker login http://registry.hub.docker.com

docker build -t giftingapp-merchant-service .

docker tag giftingapp-merchant-service:latest sathishkumar281995/giftingapp-merchant-service:latest

docker push sathishkumar281995/giftingapp-merchant-service:latest