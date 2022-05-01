mvn clean install

docker login -u $USER_NAME -p $PASSWORD

docker build ./ -t sathishkumar281995/giftingapp-merchant-service:latest

docker push sathishkumar281995/giftingapp-merchant-service:latest
