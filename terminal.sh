# build docker image
docker build -t tam .

# start container from created image and expose to port 1433
docker run -p 1433:1433 tam