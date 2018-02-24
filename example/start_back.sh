export JAEGER_AGENT_HOST=`getent hosts jaeger | awk '{ print $1 }'`
envsubst </app/hello-service-envoy.yaml.in > /app/hello-service-envoy.yaml
FLASK_APP=helloworld.py python -m flask run --port 5001 &
envoy -c /app/hello-service-envoy.yaml --service-cluster hello-service-envoy --v2-config-only
