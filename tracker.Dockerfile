FROM golang:1.10 AS build
RUN mkdir /app
ADD . /app/
WORKDIR /app
# Here with CGO_ENABLED=0 we are saying that disable cgo and build golang application statically that means you will have all the dependencies once you copy this binary to image. -a is for re build entire packages to be sure you have all the dependencies. After this execution, you will have a binary inside your project folder.
RUN go get github.com/gorilla/websocket \
    && go get github.com/gorilla/mux \
    && go get github.com/go-redis/redis \
    && CGO_ENABLED=0 GOOS=linux go build -a -installsuffix cgo -o gotracker tracker.go


FROM alpine
COPY --from=build /app/gotracker /usr/local/bin/gotracker
EXPOSE 8787
CMD ["/usr/local/bin/gotracker"]

