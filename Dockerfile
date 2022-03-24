# current ubuntu lts
FROM ubuntu:22.04

# user
ARG USER=developer
ARG GROUP=developer
ARG UID=4999

# versions
ARG GRADLE_VERSION=7.4.1
ARG JAVA_VERSION=18-zulu 
ARG MAVEN_VERSION=3.8.5
ARG NODE_VERSION=16.14.2
ARG NVM_VERSION=0.39.1
ARG BREW_VERSION=f4cd0498d9899828a340324c24dbfd0b621623aa

# switch to root user
USER root

# update & install packages
RUN apt-get update && apt-get upgrade -y && \ 
    apt-get install --no-install-recommends -y curl unzip zip git tig sudo ca-certificates ssh build-essential && \
    apt-get clean && apt-get autoremove

RUN useradd -u ${UID} -m ${USER} -d /home/${USER} -s /bin/bash && echo "${USER}:${GROUP}" | chpasswd && adduser ${USER} sudo && \
    echo '%sudo ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers

# switch to non-root user
USER ${USER}
WORKDIR /home/${USER}

# set shell
SHELL ["/bin/bash", "-c"]

# install sdkman
RUN curl -s "https://get.sdkman.io" | bash && \
    source "$HOME/.sdkman/bin/sdkman-init.sh" && \
    sed -i 's/sdkman_curl_connect_timeout=7/sdkman_curl_connect_timeout=20/g' $HOME/.sdkman/etc/config && \
    sed -i 's/sdkman_curl_max_time=10/sdkman_curl_max_time=0/g' $HOME/.sdkman/etc/config && \
    sdk update && \
    sdk install java ${JAVA_VERSION} && \
    sdk install maven ${MAVEN_VERSION} && \
    sdk install gradle ${GRADLE_VERSION}

# install nvm & node
RUN curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v${NVM_VERSION}/install.sh | bash && \
    export NVM_DIR="${HOME}/.nvm" && \
    [ -s "$NVM_DIR/nvm.sh" ] && \ 
    \. "$NVM_DIR/nvm.sh" && \
    nvm install ${NODE_VERSION}

## install brew
RUN /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/${BREW_VERSION}/install.sh)" && \
    echo 'eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"' >> /home/${USER}/.bashrc && \
    eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"    

# startup
ENTRYPOINT bash
