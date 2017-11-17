Run
```
docker run -d -e COLLECTOR_ZIPKIN_HTTP_PORT=9411 -p5775:5775/udp -p6831:6831/udp -p6832:6832/udp \
  -p5778:5778 -p16686:16686 -p14268:14268 -p9411:9411 --name jaeger jaegertracing/all-in-one:latest
docker run --link jaeger:jaeger -d -p 8080:8080 rnburn/envoyhello:0.1
curl 127.0.0.1:8080
```

Visit http://localhost:16686/ and you'll see some traces for envoy.
