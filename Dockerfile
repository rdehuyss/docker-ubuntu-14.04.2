FROM ubuntu:14.04.2

# Ubuntu 14.04.2 Docker Base with SSH login
MAINTAINER Ronald Dehuysser <ronald.dehuysser@vdab.be>

# apt-get update & upgrade and fix pam; see https://github.com/docker/docker/issues/5704
RUN apt-get update -y
RUN apt-get upgrade -y
RUN apt-get -y build-dep pam
#Rebuild and istall libpam with --disable-audit option
RUN export CONFIGURE_OPTS=--disable-audit && cd /root && apt-get -b source pam && dpkg -i libpam-doc*.deb libpam-modules*.deb libpam-runtime*.deb libpam0g*.deb

# Install sshd
RUN apt-get install -y openssh-server
RUN mkdir /var/run/sshd
RUN echo 'root:admin' | chpasswd
RUN sed -i 's/PermitRootLogin without-password/PermitRootLogin yes/' /etc/ssh/sshd_config
RUN sed 's@session\s*required\s*pam_loginuid.so@session optional pam_loginuid.so@g' -i /etc/pam.d/sshd
RUN echo "export VISIBLE=now" >> /etc/profile

# Prepare to install Hornetq
RUN apt-get install -y libaio1 net-tools bc
RUN ln -s /usr/bin/awk /bin/awk
RUN mkdir /var/lock/subsys

# Expose ports
EXPOSE 22

CMD service /usr/sbin/sshd -D