FROM debian:bookworm

ARG DEBIAN_FRONTEND=noninteractive

RUN apt-get update \
    && apt-get install -y --no-install-recommends \
       sudo systemd systemd-sysv \
       build-essential wget libffi-dev libssl-dev procps \
       python3-pip python3-dev python3-setuptools python3-wheel python3-apt \
       iproute2 \
       dbus \
       cron \
       kmod \
    && rm -rf /var/lib/apt/lists/* \
    && rm -Rf /usr/share/doc && rm -Rf /usr/share/man \
    && apt-get clean

RUN rm -f /lib/systemd/system/multi-user.target.wants/getty.target

# Add vagrant user with password 'vagrant' and configure passwordless sudo
RUN useradd -m -s /bin/bash vagrant && \
    echo "vagrant:vagrant" | chpasswd && \
    usermod -aG sudo vagrant && \
    echo "vagrant ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d/vagrant && \
    chmod 0440 /etc/sudoers.d/vagrant

VOLUME ["/sys/fs/cgroup"]
CMD ["/lib/systemd/systemd"]
