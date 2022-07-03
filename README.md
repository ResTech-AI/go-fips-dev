# Usage Instruction

## Description

This project is to proivde a docker container that provides `vs-code` based golang development environment. It automatically install FIPS validated boring crypto based go complier provided by [google](https://go-boringcrypto.storage.googleapis.com/)

## Usage
```bash
# Build the image
sudo docker build . --rm -t localhost/boring-go-dev  --build-arg GOLANG_VERSION=1.18.3b7

# Run the container
sudo docker run --rm -dt localhost/boring-go-dev:1.18.3b7
```
## Note
Default `ENTRYPOINT` runs a infinite loop shell to keep it waiting for `vs-code` to connect. This is intended to use vs-code based `golang` development inside container that provides FIPS based boringcrypto go compiler. DONOT run contianer in interactive mode.