FROM debian:bookworm

RUN apt-get update && apt-get insatll -y \
	wget

RUN wget -O /usr/bin/cadvisor https://github.com/google/cadvisor/releases/download/v0.47.0/cadvisor
	&& chmod +x cadvisor

# -logtostderrr switch from /var/log to stderre
ENTRYPOINT ["cadvisor", "-logtostderr"]






