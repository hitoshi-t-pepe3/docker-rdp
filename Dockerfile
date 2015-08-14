FROM centos:centos6
MAINTAINER pepechoko <hitoshi.t.pepechoko@gmail.com>


# epel install 
RUN rpm -Uvh http://dl.fedoraproject.org/pub/epel/6/x86_64/epel-release-6-8.noarch.rpm

RUN yum install -y \
  Xvfb \
  xrdp \
  xfce4

ADD startwm.sh /etc/xrdp/startwm.sh

CMD xrdp -nodaemon 
