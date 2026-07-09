FROM debian:bookworm

RUN apt-get update && apt-get install -y \
	wget \
	&& rm -rf /var/lib/apt/lists/*


RUN wget -O /usr/bin/cadvisor https://github.com/google/cadvisor/releases/download/v0.60.3/cadvisor-v0.60.3-linux-amd64 \
	&& chmod +x /usr/bin/cadvisor

# -logtostderrr switch from /var/log to stderre

ENTRYPOINT ["cadvisor", "-logtostderr"]






