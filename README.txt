How to use this Docker image:

 1. First, build the MetaCat server one (cd git/metacat/docker/server; sudo ./build.sh)

 2. cd to this directory and build this image (sudo docker build -t metacat_test .)

 3. Run it (sudo docker run -ti --rm -p 8080:8080 --name metacat_test metacat_test)

 4. Access the server at http://localhost:8080/. Login with username admin, password admin.

No need to mount volume for config or anything like that.
