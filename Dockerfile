# current lts
FROM ubuntu:20.04

# update install packages
RUN apt-get update && \ 
    apt-get -y install sudo && \
    apt-get install curl -y && \
    apt-get install unzip && \
    apt-get install zip

# set shell
SHELL ["/bin/bash", "-c"]

# install nvm
RUN sudo curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.1/install.sh | bash && \
    export NVM_DIR="${HOME}/.nvm" && \
    [ -s "$NVM_DIR/nvm.sh" ] && \ 
    \. "$NVM_DIR/nvm.sh" && \
    nvm install 16

# install sdkman
RUN sudo curl -s "https://get.sdkman.io" | bash && \
    source "$HOME/.sdkman/bin/sdkman-init.sh"

# startup
ENTRYPOINT bash
