FROM redhat/ubi8-minimal AS prepare
ARG GOLANG_VERSION=1.18.3b7
# go1.18.3b7.linux-amd64.tar.gz
RUN microdnf update && microdnf install -y wget gzip tar\
&& mkdir -p /opt/go

# Get boringcryto based golang binary from Google.
RUN wget -q -O go-fips.tgz "https://go-boringcrypto.storage.googleapis.com/go$GOLANG_VERSION.linux-amd64.tar.gz" \
&& tar -C /opt/go -xzf go-fips.tgz \
&& rm go-fips.tgz

FROM redhat/ubi8-minimal

LABEL Version='1.18b7-1.0' Description='This is golang ${GOLANG_VERSION} development environment based on FIPS 140-2 validated boring crypto. \
This may be used to compile any golang binary that need FIPS 140-2 compliance. See here https://github.com/golang/go/blob/dev.boringcrypto/README.boringcrypto.md the statement about FIPS validation from Google.'

COPY --from=prepare /opt/go /usr/local/
RUN mkdir -p /opt/scripts
COPY ./src/entrypoint.sh /opt/scripts/

ENV GOROOT=/usr/local/go 
ENV PATH="$GOROOT/bin:$PATH"


# Install development dependencies and git
RUN microdnf update && microdnf install -y \
gcc \
git \
make \
&& microdnf clean all \
&& touch /etc/profile.d/go-path.sh \
&& echo "export PATH=${GOROOT}/bin:${PATH}" > tee /etc/profile.d/go-path.sh \
# && mkdir -p /opt/scripts \
&& chmod 744 /etc/profile.d/go-path.sh \
&& chmod 744 /opt/scripts/entrypoint.sh

VOLUME [ "/opt/dev","/etc/ssl","/root/.ssh" ]
WORKDIR /opt/dev

# Needed by vscode but can be installed on-demand from vs-code

RUN go install -v golang.org/x/tools/gopls@latest 
RUN go install -v github.com/uudashr/gopkgs/v2/cmd/gopkgs@latest 
RUN go install -v github.com/ramya-rao-a/go-outline@latest 
RUN go install -v github.com/go-delve/delve/cmd/dlv@latest 
RUN go install -v golang.org/x/lint/golint@latest


ENTRYPOINT ["/opt/scripts/entrypoint.sh"]

