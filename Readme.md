# Developer Environment

Developer environment for use with VSCode remote container extension.

## Image contains: 
### Languages & Tools
- [nvm](https://github.com/nvm-sh/nvm)
- [node](https://nodejs.org/en/) 
- [sdkman](https://sdkman.io/) 
- [java](https://www.azul.com/downloads/?package=jdk)
- [gradle](https://gradle.org/)
- [maven](https://maven.apache.org/)

### Utilities
- zip/unzip
- curl
- git
- tig

## Build
> docker build -t niroe/dev-env .

## Run (background)
> docker run --name dev-environment -td niroe/dev-env .

## Run (bash)
> docker run --name dev-environment -it niroe/dev-env
