FROM alpine:3.20

WORKDIR /code

ARG TF_VERSION=1.5.7

RUN apk update && \
    # Install terraform \
    apk add --virtual .deps --no-cache gnupg && \
    cd /tmp && \
    wget https://releases.hashicorp.com/terraform/${TF_VERSION}/terraform_${TF_VERSION}_linux_amd64.zip && \
    wget https://releases.hashicorp.com/terraform/${TF_VERSION}/terraform_${TF_VERSION}_SHA256SUMS && \
    wget https://releases.hashicorp.com/terraform/${TF_VERSION}/terraform_${TF_VERSION}_SHA256SUMS.sig && \
    wget -qO- https://www.hashicorp.com/.well-known/pgp-key.txt | gpg --import && \
    gpg --verify terraform_${TF_VERSION}_SHA256SUMS.sig terraform_${TF_VERSION}_SHA256SUMS && \
    grep terraform_${TF_VERSION}_linux_amd64.zip terraform_${TF_VERSION}_SHA256SUMS | sha256sum -c && \
    unzip /tmp/terraform_${TF_VERSION}_linux_amd64.zip -d /tmp && \
    mv /tmp/terraform /usr/local/bin/terraform && \
    rm -f /tmp/terraform_${TF_VERSION}_linux_amd64.zip terraform_${TF_VERSION}_SHA256SUMS ${TF_VERSION}/terraform_${TF_VERSION}_SHA256SUMS.sig && \
    apk del .deps
