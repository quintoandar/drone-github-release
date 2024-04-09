FROM golang:1.20
WORKDIR /go/src/github.com/drone-plugins/drone-github-release
ADD . .
RUN go mod download
RUN CGO_ENABLED=0 GOOS=linux go build -a -tags netgo -trimpath -ldflags='-buildid= -w -s -extldflags "-static"' -o /tmp/drone-github-release github.com/drone-plugins/drone-github-release/cmd/drone-github-release

FROM scratch
LABEL maintainer="QuintoAndar <github.com/quintoandar>"
COPY --from=0 /tmp/drone-github-release /bin/
COPY --from=0 /etc/ssl/certs/ca-certificates.crt /etc/ssl/certs/

EXPOSE 8080
ENTRYPOINT ["/bin/drone-github-release"]
