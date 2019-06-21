FROM registry.access.redhat.com/openshift3/jenkins-slave-base-rhel7

MAINTAINER Akram Ben Aissi <abenaiss@redhat.com>

# Labels consumed by Red Hat build service

# Install OpenJDK
RUN yum-config-manager --enable rhel-server-rhscl-7-rpms && \    
    yum-config-manager --disable epel >/dev/null || : && \
    INSTALL_PKGS="java-1.8.0-openjdk-devel.x86_64 java-1.8.0-openjdk-devel.i686 " && \
    yum install -y $INSTALL_PKGS && \
    rpm -V ${INSTALL_PKGS//\*/} && \
    yum clean all -y && \
    mkdir -p $HOME/.m2 
RUN cd /usr/local/ && \
    curl https://repo.maven.apache.org/maven2/org/apache/maven/apache-maven/3.5.0/apache-maven-3.5.0-bin.tar.gz | tar zxvf - && \ 
    ln -s /usr/local/apache-maven-3.5.0/bin/mvn /usr/local/bin/mvn

ADD contrib/bin/configure-slave /usr/local/bin/configure-slave
ADD ./contrib/settings.xml $HOME/.m2/

RUN chown -R 1001:0 $HOME && \
    chmod -R g+rw $HOME

USER 1001


