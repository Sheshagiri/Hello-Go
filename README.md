# Hello-Go
Simple hello world http server written in Go.

# Clone
`
sheshagiri@ubuntu:~$ git clone http://github.com/Sheshagiri/Hello-Go

Cloning into 'Hello-Go'...
remote: Counting objects: 19, done.
remote: Compressing objects: 100% (19/19), done.
remote: Total 19 (delta 7), reused 0 (delta 0), pack-reused 0
Unpacking objects: 100% (19/19), done.
Checking connectivity... done.
`
# Build
`
sheshagiri@ubuntu:~$ cd Hello-Go/
sheshagiri@ubuntu:~/Hello-Go$ sudo docker build -t hello-go:1 .
Sending build context to Docker daemon  83.46kB
Step 1/9 : FROM golang
 ---> d0e7a411e3da
Step 2/9 : LABEL maintainer "msheshagirirao@gmail.com"
 ---> Using cache
 ---> e6871e4f23a7
Step 3/9 : HEALTHCHECK --interval=5s             --timeout=5s             CMD curl -f http://127.0.0.1:8000 || exit 1
 ---> Using cache
 ---> 38a4b43904bc
Step 4/9 : ADD . /go/src/github.com/Hello-Go
 ---> 299569fe2bda
Step 5/9 : RUN ls
 ---> Running in 071fac49cefc
bin
src
Removing intermediate container 071fac49cefc
 ---> 176b4ffebd67
Step 6/9 : WORKDIR /go/src/github.com/Hello-Go
 ---> Running in ff83b844d18c
Removing intermediate container ff83b844d18c
 ---> d9c58f54468b
Step 7/9 : RUN go build
 ---> Running in e9037103cd92
Removing intermediate container e9037103cd92
 ---> be143700fe01
Step 8/9 : EXPOSE 8000
 ---> Running in 3d8d879d62ab
Removing intermediate container 3d8d879d62ab
 ---> 2d290e30e3c6Step 9/9 : CMD ./Hello-Go ---> Running in 9ed3c7c6ab1a
Removing intermediate container 9ed3c7c6ab1a
 ---> 3fa06ac04eab
Successfully built 3fa06ac04eab
Successfully tagged hello-go:1
`
`
sheshagiri@ubuntu:~/Hello-Go$ sudo docker images | grep hello-go
hello-go                                                                     1                   3fa06ac04eab        About a minute ago   801MB
`
# Run
sheshagiri@ubuntu:~/Hello-Go$ `sudo docker  run -d --name hello-go -p 8000:8000 hello-go:1`
a6a1d4213f6192a2009dbd95c038e6685e27dd890d8a15a8264bba4f16b7c632
sheshagiri@ubuntu:~/Hello-Go$ `sudo docker ps | grep hello-go`
a6a1d4213f61        hello-go:1          "/bin/sh -c ./Hello-…"   26 seconds ago      Up 26 seconds (healthy)   0.0.0.0:8000->8000/tcp   hello-go
# Verify
sheshagiri@ubuntu:~/Hello-Go$ `curl localhost:8000`
Hello 
sheshagiri@ubuntu:~/Hello-Go$ `curl localhost:8000/Sheshagiri`
Hello Sheshagiri
