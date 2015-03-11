FROM ubuntu:14.04.2

# Ubuntu 14.04.2 Docker Base with SSH login
MAINTAINER Ronald Dehuysser <ronald.dehuysser@vdab.be>

# apt-get update & upgrade and fix pam; see https://github.com/docker/docker/issues/5704
RUN apt-get update -y && apt-get upgrade -y && apt-get -y build-dep pam && apt-get clean
#Rebuild and istall libpam with --disable-audit option
RUN export CONFIGURE_OPTS=--disable-audit && \
	cd /root && \
	apt-get -b source pam && \
	dpkg -i libpam-doc*.deb libpam-modules*.deb libpam-runtime*.deb libpam0g*.deb && \
	rm -rf /root/*
	

# Install sshd
RUN apt-get install -y openssh-server; apt-get clean && \
	mkdir /var/run/sshd && \
	echo 'root:admin' | chpasswd && \
	sed -i 's/PermitRootLogin without-password/PermitRootLogin yes/' /etc/ssh/sshd_config && \
	sed 's@session\s*required\s*pam_loginuid.so@session optional pam_loginuid.so@g' -i /etc/pam.d/sshd && \
	echo "export VISIBLE=now" >> /etc/profile

# Prepare to install Hornetq
RUN apt-get install -y libaio1 net-tools bc; apt-get clean && \
	ln -s /usr/bin/awk /bin/awk && \
	mkdir /var/lock/subsys

RUN rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Expose ports
EXPOSE 22

CMD service /usr/sbin/sshd -D
