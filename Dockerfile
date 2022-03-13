# current ubuntu lts
FROM ubuntu:20.04

ARG USER=developer

USER root
# update & install packages
RUN apt-get update && apt-get upgrade && \ 
    apt-get install --no-install-recommends -y curl unzip zip git tig sudo ca-certificates && \
    apt-get clean 

RUN useradd -m ${USER} -s /bin/bash && echo "${USER}:${USER}" | chpasswd && adduser ${USER} sudo && \
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
    nvm install 16

# install sdkman - maven, gradle & java 17
RUN curl -s "https://get.sdkman.io" | bash && \
    source "$HOME/.sdkman/bin/sdkman-init.sh" && \
    sed -i 's/sdkman_curl_connect_timeout=7/sdkman_curl_connect_timeout=20/g' $HOME/.sdkman/etc/config && \
    sed -i 's/sdkman_curl_max_time=10/sdkman_curl_max_time=0/g' $HOME/.sdkman/etc/config && \
    sdk update && \
    sdk install java 17.0.2-zulu && \
    sdk install maven 3.8.4 && \
    sdk install gradle 7.4.1

# startup
ENTRYPOINT bash
