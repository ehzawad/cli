FROM ubuntu:14.04

# ENV
ENV DEBIAN_FRONTEND noninteractive
RUN locale-gen "en_US.UTF-8" && dpkg-reconfigure locales
ENV LANG "en_US.UTF-8"
ENV LC_ALL "en_US.UTF-8"
ENV LC_CTYPE "en_US.UTF-8"
ENV PATH /opt/cs50/bin:"$PATH"
ENV TERM ansi

#
RUN mkdir -p /opt/bin

# packages
RUN apt-get update && \
    apt-get install -y \
        bash-completion \
        bsdtar \
        build-essential \
        clang \
        curl \
        gdb \
        gettext-base \
        git \
        info \
        man \
        nano \
        openjdk-7-jdk \
        openjdk-7-jre-headless \
        nodejs \
        npm \
        perl \
        php5-cli \
        php5-curl \
        php5-gmp \
        php5-intl \
        php5-mcrypt \
        python \
        python-dev \
        python-pip \
        python3 \
        python3-dev \
        python3-pip \
        rpm \
        ruby \
        ruby-dev \
        software-properties-common \
        telnet \
        valgrind \
        vim \
        wget

# fpm
RUN gem install fpm

# composer
RUN curl -L -o /usr/local/bin/composer https://getcomposer.org/composer.phar && chmod a+x /usr/local/bin/composer

# environment
COPY ./etc/motd /etc/
COPY ./etc/profile.d/cli50.sh /etc/profile.d/
COPY ./etc/vim/vimrc.local /etc/vim/

# TEMPORARY FOR asciidoc50 UNTIL MOVED INTO DEB
#RUN locale-gen "en_US.UTF-8" && \
#    dpkg-reconfigure locales && \
#        apt-get install -y rubygems-integration
#RUN dpkg-reconfigure locales && \
#        apt-get install -y rubygems-integration
#
# to avoid man sudoers complaining with "man: can't set the locale; make sure $LC_* and $LANG are correct"
RUN gem install \
        asciidoctor \
        coderay \
        thread_safe \
        tilt
COPY ./asciidoc50 /opt/asciidoc50
RUN chmod a+x /opt/asciidoc50/bin/asciidoc50
ENV PATH "$PATH:/opt/asciidoc50/bin"

# ubuntu
# TODO: decide if this breaks child files
#RUN useradd --create-home --groups sudo --home-dir /home/ubuntu --shell /bin/bash ubuntu && \
#    chown -R ubuntu:ubuntu /home/ubuntu && \
#    sed -i 's/^%sudo\s.*/%sudo ALL=NOPASSWD:ALL/' /etc/sudoers

# bash
#RUN echo export PS1='\[$(printf "\x0f")\033[01;34m\]\w\[\033[00m\]$(__git_ps1 " (%s)") $ ' >> /home/ubuntu/foo

# entrypoint
#ENTRYPOINT ["sudo", "-i", "-u", "ubuntu", "sh", "-c"]
#CMD ["cd workspace ; bash -l"]
WORKDIR /root
CMD ["bash", "-l"]
