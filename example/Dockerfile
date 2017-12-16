FROM rnburn/envoy-jaeger:0.12

WORKDIR /app

ADD . /app

RUN  apt-get update \
  && apt-get install --no-install-recommends --no-install-suggests -y \
              python-pip \
              python-dev \
              build-essential \
              python-setuptools \
              gettext \
              vim \
              gdb
RUN ln -s /usr/local/lib/libjaegertracingd.so /usr/local/lib/libjaegertracing.so
RUN pip install -r requirements.txt

EXPOSE 8080
EXPOSE 8001
EXPOSE 8002
EXPOSE 8003

CMD ["sh", "/app/start-helloworld.sh"]
