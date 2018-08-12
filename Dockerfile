#from golang image
FROM golang

# set maintainer
LABEL maintainer "msheshagirirao@gmail.com"

# set a health check
HEALTHCHECK --interval=5s \
            --timeout=5s \
            CMD curl -f http://127.0.0.1:8000 || exit 1

ADD . /go/src/github.com/Hello-Go
RUN ls 
WORKDIR /go/src/github.com/Hello-Go

RUN go build

# tell docker what port to expose
EXPOSE 8000

CMD ./Hello-Go
