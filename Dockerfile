FROM ubuntu:17.10
RUN set -x \
# save list of currently-installed packages so build dependencies can be cleanly removed later
	&& savedAptMark="$(apt-mark showmanual)" \
# new directory for storing sources and .deb files
	#&& tempDir="$(mktemp -d)" \
	&& tempDir=/src \
  && mkdir $tempDir \
	&& chmod 777 "$tempDir" \
# (777 to ensure APT's "_apt" user can access it too)
  && apt-get update \
  && apt-get install --no-install-recommends --no-install-suggests -y \
              build-essential \
              cmake \
              curl \
              git \
              ca-certificates \
              golang \
              realpath \
              wget \
              automake \
              autogen \
              autoconf \
              libtool \
              m4 \
  && cd "$tempDir" \
# Build OpenTracing
  && git clone https://github.com/opentracing/opentracing-cpp.git \
  && cd opentracing-cpp \
  && mkdir .build && cd .build \
  && cmake -DCMAKE_BUILD_TYPE=Debug -DBUILD_TESTING=OFF -DCMAKE_CXX_FLAGS="-fPIC" .. \
  && make && make install \
  && cd "$tempDir" \
## Build jaeger
  && git clone https://github.com/rnburn/cpp-client.git \
  && cd cpp-client \
  && mkdir .build && cd .build \
  && cmake -DCMAKE_BUILD_TYPE=Debug -DBUILD_TESTING=OFF .. \
  && make && make install \
  && cd "$tempDir" \
# Install bazel
  && apt-get install --no-install-recommends --no-install-suggests -y \
              openjdk-8-jdk \
  && echo "deb [arch=amd64] http://storage.googleapis.com/bazel-apt stable jdk1.8" | tee /etc/apt/sources.list.d/bazel.list \
  && curl https://bazel.build/bazel-release.pub.gpg | apt-key add - \
  && apt-get update \
  && apt-get install --no-install-recommends --no-install-suggests -y \
              bazel \
  && apt-get upgrade -y bazel \
# reset apt-mark's "manual" list so that "purge --auto-remove" will remove all build dependencies
# (which is done after we install the built packages so we don't have to redownload any overlapping dependencies)
	&& apt-mark showmanual | xargs apt-mark auto > /dev/null \
	&& { [ -z "$savedAptMark" ] || apt-mark manual $savedAptMark; } \
	\
  && cd "$tempDir" \
## Build envoy
  && git clone -b dynamic-tracing https://github.com/rnburn/envoy.git \
  && cd envoy \
  && bazel fetch //source/... \
  && bazel build -c dbg //source/exe:envoy-static \
  && mv bazel-bin/source/exe/envoy-static /usr/bin/envoy \
  && cd "$tempDir" 
	# if we have leftovers from building, let's purge them (including extra, unnecessary build deps)
	#&& if [ -n "$tempDir" ]; then \
	#	apt-get purge -y --auto-remove \
	#	&& rm -rf "$tempDir" /etc/apt/sources.list.d/temp.list; \
	#fi
