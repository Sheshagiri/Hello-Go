# Hello-Go [![Build Status](https://travis-ci.com/Sheshagiri/Hello-Go.png?branch=master)](https://travis-ci.com/Sheshagiri/Hello-Go)
Simple hello world http server written in Go.

# Clone
sheshagiri@ubuntu:~$ `git clone http://github.com/Sheshagiri/Hello-Go`

# Build
sheshagiri@ubuntu:~$ `cd Hello-Go/`


sheshagiri@ubuntu:~/Hello-Go$ `sudo docker build -t hello-go:1 .`

sheshagiri@ubuntu:~/Hello-Go$ `sudo docker images | grep hello-go`
# Run
sheshagiri@ubuntu:~/Hello-Go$ `sudo docker  run -d --name hello-go -p 8000:8000 hello-go:1`

sheshagiri@ubuntu:~/Hello-Go$ `sudo docker ps | grep hello-go`
# Verify
sheshagiri@ubuntu:~/Hello-Go$ `curl localhost:8000`

Hello

sheshagiri@ubuntu:~/Hello-Go$ `curl localhost:8000/Sheshagiri`

Hello Sheshagiri
