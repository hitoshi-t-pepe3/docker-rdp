FROM centos:centos6
MAINTAINER pepechoko <hitoshi.t.pepechoko@gmail.com>

# epel install 
RUN rpm -Uvh http://dl.fedoraproject.org/pub/epel/6/x86_64/epel-release-6-8.noarch.rpm

RUN \
  yum install -y \
		Xvfb \
		supervisor \
		tigervnc-server \
		xrdp \
		wget \
  && yum groupinstall -y Xfce \ 
  && yum -y install \
		xorg-x11-fonts-Type1 xorg-x11-fonts-misc \
  && yum clean all

ADD startwm.sh /etc/xrdp/startwm.sh

ADD vncservers /etc/sysconfig/vncservers

RUN mkdir -p /.vnc
RUN echo password | vncpasswd -f > /.vnc/passwd
RUN chmod 600 /.vnc/passwd

ADD supervisord.conf /etc/supervisord.conf

RUN groupadd xrdp \
  && adduser testuser1 -p password -G xrdp -m

USER testuser1

RUN echo xfce4-session >~/.xsession

USER root
EXPOSE 3389

CMD ["/usr/bin/supervisord","-n"]

