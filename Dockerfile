# current lts
FROM ubuntu:20.04

# update image
RUN apt-get update && apt-get -y install sudo && apt-get install wget -y && apt-get install curl -y

# set shell
SHELL ["/bin/bash", "-c"]

# install nvm
RUN sudo curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.1/install.sh | bash && \
    export NVM_DIR="${HOME}/.nvm" && \
    [ -s "$NVM_DIR/nvm.sh" ] && \ 
    \. "$NVM_DIR/nvm.sh" && \
    nvm install 16

# startup
ENTRYPOINT bash
