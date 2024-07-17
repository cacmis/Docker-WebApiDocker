echo "Construir la Imagen Docker"
cd MyWebAPIDemo

docker build -t mywebapidemo .
#docker run -it -p 5050:80 --name mywebapidemo_container mywebapidemo
docker run -it -p 5051:8080 --name mywebapidemo_container mywebapidemo

