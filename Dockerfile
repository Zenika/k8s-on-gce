FROM python:2.7-alpine

ENV TERRAFORM_VERSION=0.11.3 \
    GCLOUD_SDK_VERSION=200.0.0 \
    CFSSL_VERSION=R1.2 \
    KUBE_VERSION=v1.12.2

ENV GCLOUD_SDK_FILE=google-cloud-sdk-${GCLOUD_SDK_VERSION}-linux-x86_64.tar.gz \
    TERRAFORM_FILE=terraform_${TERRAFORM_VERSION}_linux_amd64.zip

RUN apk update && \
    apk add bash curl git openssh-client gcc make musl-dev libffi-dev openssl-dev && \
    curl -o /root/$GCLOUD_SDK_FILE https://dl.google.com/dl/cloudsdk/channels/rapid/downloads/$GCLOUD_SDK_FILE && \
    curl -o /usr/local/bin/cfssl https://pkg.cfssl.org/$CFSSL_VERSION/cfssl_linux-amd64 && \
    curl -o /usr/local/bin/cfssljson https://pkg.cfssl.org/$CFSSL_VERSION/cfssljson_linux-amd64 && \
    curl -o /usr/local/bin/kubectl https://storage.googleapis.com/kubernetes-release/release/$KUBE_VERSION/bin/linux/amd64/kubectl && \
    curl -o /root/$TERRAFORM_FILE https://releases.hashicorp.com/terraform/$TERRAFORM_VERSION/$TERRAFORM_FILE

WORKDIR /root

RUN unzip $TERRAFORM_FILE && \
    mv terraform /usr/local/bin && \
    rm $TERRAFORM_FILE && \
    tar xzf $GCLOUD_SDK_FILE && \
    /root/google-cloud-sdk/install.sh -q && \
    /root/google-cloud-sdk/bin/gcloud config set disable_usage_reporting true && \
    rm /root/${GCLOUD_SDK_FILE} && \
    chmod +x /usr/local/bin/cfssl* /usr/local/bin/kubectl && \
    pip2 install ansible

ADD profile /root/.bashrc
ADD ansible.cfg /root/.ansible.cfg

WORKDIR /root/app

ENTRYPOINT [ "/bin/bash" ]

