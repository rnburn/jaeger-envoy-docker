export JAEGER_AGENT_HOST=`getent hosts jaeger | awk '{ print $1 }'`
envsubst </app/front-envoy.yaml.in >/app/front-envoy.yaml
envoy -c /app/front-envoy.yaml --service-cluster front-proxy --v2-config-only
