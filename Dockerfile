FROM debian:stretch-slim

RUN apt-get update && apt-get install -y \
    g++ \
    make \
    ruby \
    python3 \
    ffmpeg \
    librtmp-dev

COPY . /usr/local/src/peercast-yt

RUN cd /usr/local/src/peercast-yt/ui/linux && \
    make && \
    tar zxfv peercast-yt-linux-*.tar.gz -C /root && \
    cp ../../bvt/peercast.ini.master /root/peercast-yt

WORKDIR /root/peercast-yt

RUN apt-get purge -y --auto-remove g++ make && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* && \
    rm -rf /usr/local/src/peercast-yt

COPY docker-entrypoint.sh /usr/local/bin/
ENTRYPOINT ["docker-entrypoint.sh"]

EXPOSE 7144
CMD ["./peercast"]
