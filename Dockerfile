FROM ubuntu:focal-20210217

ENV DCV_IMAGE_VERSION=0.0.1

LABEL maintainer="leonjohan3@gmail.com" \
      io.openshift.s2i.scripts-url="image:///usr/libexec/s2i" \
      description="The creation of a docker image that is based on Ubuntu 20.04 LTS, and is tuned to be suitable as a base for s2i-dcv-test/prod images." \
      dbv.image.version="${DCV_IMAGE_VERSION}"

RUN export DEBIAN_FRONTEND=noninteractive \
    && ln -nfs /usr/share/zoneinfo/Australia/Sydney /etc/localtime \
    && echo "Australia/Sydney" > /etc/timezone \
    && apt-get -y update \
    && apt-get -y install apt-utils \
    && apt-get -y upgrade -o Dpkg::Options::="--force-confold" \
    && apt-get -y update \
    && apt-get -y install locales tzdata default-jre runit curl \
    && localedef -i en_AU -c -f UTF-8 -A /usr/share/locale/locale.alias en_AU.UTF-8 \
    && dpkg-reconfigure -f noninteractive tzdata \
    && apt-get -y clean \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* \
    && rm -r /usr/share/man \
    && rm -r /usr/share/doc

RUN export DEBIAN_FRONTEND=noninteractive && apt-get -y update && apt-get -y install less tree apache2
RUN export DEBIAN_FRONTEND=noninteractive && apt-get -y update && apt-get -y install tomcat9

ENV LANG=en_AU.UTF-8
ARG APP_HOME=/opt/app-root/src

# Create the user that will run the application.
RUN update-locale LANG=en_AU.UTF-8 \
    && mkdir /opt/app-root \
    && useradd -G adm -c "Default Application User" -d ${APP_HOME} -g root -m -s /usr/sbin/nologin -u 11001 default

COPY dot_bash_aliases ${APP_HOME}/.bash_aliases
COPY dot_bash_aliases /root/.bash_aliases

RUN chown -R default ${APP_HOME}

# Run as the default user.
# The user needs to be set to default in the leaf image.
USER default
#CMD ["/usr/sbin/apache2 -d $HOME/etc"]