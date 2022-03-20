# current ubuntu lts
FROM ubuntu:20.04

ARG USER=developer
ARG GROUP=developer
ARG UID=4999

# versions
ARG GRADLE_VERSION=7.4.1
ARG JAVA_VERSION=17.0.2-zulu 
ARG MAVEN_VERSION=3.8.4
ARG NODE_VERSION=16

USER root
# update & install packages
RUN apt-get update && apt-get upgrade && \ 
    apt-get install --no-install-recommends -y curl unzip zip git tig sudo ca-certificates ssh && \
    apt-get clean 

RUN useradd -u ${UID} -m ${USER} -s /bin/bash && echo "${USER}:${GROUP}" | chpasswd && adduser ${USER} sudo && \
    echo '%sudo ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers

# switch to non-root user
USER ${USER}
WORKDIR /home/${USER}

# setup directory for .ssh keys
RUN mkdir -p $HOME/dev/.ssh && ln -s $HOME/dev/.ssh $HOME/.ssh

# set shell
SHELL ["/bin/bash", "-c"]

# install nvm - node 16
RUN curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.1/install.sh | bash && \
    export NVM_DIR="${HOME}/.nvm" && \
    [ -s "$NVM_DIR/nvm.sh" ] && \ 
    \. "$NVM_DIR/nvm.sh" && \
    nvm install ${NODE_VERSION} && \
    npm i -g yarn

# install sdkman - maven, gradle & java 17
RUN curl -s "https://get.sdkman.io" | bash && \
    source "$HOME/.sdkman/bin/sdkman-init.sh" && \
    sed -i 's/sdkman_curl_connect_timeout=7/sdkman_curl_connect_timeout=20/g' $HOME/.sdkman/etc/config && \
    sed -i 's/sdkman_curl_max_time=10/sdkman_curl_max_time=0/g' $HOME/.sdkman/etc/config && \
    sdk update && \
    sdk install java ${JAVA_VERSION} && \
    sdk install maven ${MAVEN_VERSION} && \
    sdk install gradle ${GRADLE_VERSION}

# startup
ENTRYPOINT bash
