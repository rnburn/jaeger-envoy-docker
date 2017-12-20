export JAEGER_AGENT_HOST=`getent hosts jaeger | awk '{ print $1 }'`
envsubst </app/envoy-jaeger.yaml >/etc/envoy-jaeger.yaml
envoy -c front-envoy.json --service-cluster front-proxy 
