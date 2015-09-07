FROM centos:centos6
MAINTAINER pepechoko <hitoshi.t.pepechoko@gmail.com>

# epel install 
RUN rpm -Uvh http://dl.fedoraproject.org/pub/epel/6/x86_64/epel-release-6-8.noarch.rpm

RUN \
  yum install -y \
		Xvfb \
		sudo \
		supervisor \
		tigervnc-server \
		wget \
		xrdp \
  && yum groupinstall -y Xfce \ 
  && yum -y install \
		xorg-x11-fonts-Type1 xorg-x11-fonts-misc \
  && yum clean all

ADD startwm.sh /etc/xrdp/startwm.sh
RUN chmod a+x /etc/xrdp/startwm.sh

ADD xrdp.ini /etc/xrdp/xrdp.ini 

# RUN chmod a+x /.vnc/passwd
# # ADD vncservers /etc/sysconfig/vncservers
# 
# RUN mkdir -p /.vnc
# RUN echo password | vncpasswd -f > /.vnc/passwd
# RUN chmod 600 /.vnc/passwd

ADD supervisord.conf /etc/supervisord.conf

RUN groupadd xrdp \
  && adduser testuser1 -G xrdp -m \
  && gpasswd -a testuser1 wheel  \
  && echo "testuser1:password" | chpasswd \
  && echo '%wheel ALL=(ALL) ALL' >> /etc/sudoers

RUN echo xfce4-session >/home/testuser1/.xsession \
  && chown testuser1.xrdp /home/testuser1/.xsession

EXPOSE 3389

CMD ["/usr/bin/supervisord","-n"]

