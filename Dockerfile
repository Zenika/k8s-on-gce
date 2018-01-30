FROM python:2.7-alpine

ENV TERRAFORM_FILE=terraform_0.11.2_linux_amd64.zip \
    GCLOUD_SDK=google-cloud-sdk-185.0.0-linux-x86_64.tar.gz

RUN apk update && \
    apk add bash curl git openssh-client gcc make musl-dev libffi-dev openssl-dev && \
    curl -o /root/$GCLOUD_SDK https://dl.google.com/dl/cloudsdk/channels/rapid/downloads/$GCLOUD_SDK && \
    curl -o /usr/local/bin/cfssl https://pkg.cfssl.org/R1.2/cfssl_linux-amd64 && \
    curl -o /usr/local/bin/cfssljson https://pkg.cfssl.org/R1.2/cfssljson_linux-amd64 && \
    curl -o /usr/local/bin/kubectl https://storage.googleapis.com/kubernetes-release/release/v1.9.0/bin/linux/amd64/kubectl && \
    curl -o /root/$TERRAFORM_FILE https://releases.hashicorp.com/terraform/0.11.2/$TERRAFORM_FILE

WORKDIR /root

RUN unzip $TERRAFORM_FILE && \
    mv terraform /usr/local/bin && \
    rm $TERRAFORM_FILE && \
    tar xzf $GCLOUD_SDK && \
    /root/google-cloud-sdk/install.sh -q && \
    /root/google-cloud-sdk/bin/gcloud config set disable_usage_reporting true && \
    chmod +x /usr/local/bin/cfssl* /usr/local/bin/kubectl && \
    pip2 install ansible

ADD profile /root/.bashrc
ADD ansible.cfg /root/.ansible.cfg

ENTRYPOINT [ "/bin/bash" ]

