FROM python:alpine as pythonbase
FROM alpine:latest as alpinebase

# GO Disposable IMAGE
# FROM golang:alpine as go-disposable
#     WORKDIR /salida

#     # Install tfsec
#     RUN go install github.com/aquasecurity/tfsec/cmd/tfsec@latest && \
#         which tfsec && \
#         #tfsec -v && \
#         mv /go/bin/tfsec /salida

# Python Disposable builder IMAGE
FROM python:slim as python-disposable
    
    # Install Checkov (unit test)
    RUN python -m venv /opt/venv
    ENV PATH="/opt/venv/bin:$PATH"
    RUN apt update -y && pip3 install --upgrade pip && pip3 install --upgrade setuptools && \
        pip install --no-cache-dir -U checkov 

# Common Alpine Disposable builder IMAGE
FROM alpinebase as builder-disposable 
    
    RUN apk add unzip wget curl && \
        mkdir /salida

    # Install terraform-docs
    RUN final_endpoint=$(curl -Ls -o /dev/null -w %{url_effective} https://github.com/terraform-docs/terraform-docs/releases/latest) && \
        version=$(printf "%s\n" "$final_endpoint" | rev | cut -d/ -f-1 | rev) && \
        wget -q https://github.com/terraform-docs/terraform-docs/releases/download/$version/terraform-docs-$version-linux-amd64.tar.gz -O terraform-docs.tar.gz && \
        tar -xzf terraform-docs.tar.gz && \
        chmod +x terraform-docs && \
        mv terraform-docs /salida/terraform-docs && \
        /salida/terraform-docs --version
    
    RUN wget https://github.com/stedolan/jq/releases/download/jq-1.6/jq-linux64 && \
        mv jq-linux64 /usr/local/bin/jq && \
        chmod +x /usr/local/bin/jq && \
        mv /usr/local/bin/jq /salida
    # # Install Terraform

    # ENV TF_VERSION=1.2.3
    # RUN wget -q https://releases.hashicorp.com/terraform/${TF_VERSION}/terraform_${TF_VERSION}_linux_amd64.zip && \
    #     unzip terraform_${TF_VERSION}_linux_amd64.zip && \
    #     mv terraform /salida/ && \
    #     /salida/terraform --version

    # # Install drifctl
    # RUN curl -s -L https://github.com/snyk/driftctl/releases/latest/download/driftctl_linux_amd64 -o driftctl && \
    #     chmod +x driftctl && \
    #     mv driftctl /salida/ && \
    #     /salida/driftctl version 

    # # Install infracost
    # RUN final_endpoint=$(curl -Ls -o /dev/null -w %{url_effective} https://github.com/infracost/infracost/releases/latest) && \
    #     version=$(printf "%s\n" "$final_endpoint" | rev | cut -d/ -f-1 | rev) && \
    #     echo "version to be downloaded: $version" && \
    #     wget -q https://github.com/infracost/infracost/releases/download/$version/infracost-linux-amd64.tar.gz && \
    #     tar xzf infracost-linux-amd64.tar.gz -C /tmp && \
    #     mv /tmp/infracost-linux-amd64 /salida/infracost && \
    #     /salida/infracost --version

    # # Install regula
    # RUN wget https://github.com/fugue/regula/releases/download/v2.8.0/regula_2.8.0_Linux_x86_64.tar.gz -O regula
    # RUN tar -xvf regula
    # RUN mv regula /salida
    
#     #RUN wget https://github.com/im2nguyen/rover/releases/download/v0.3.2/rover_0.3.2_linux_amd64.zip && \ 
#     #    unzip rover.zip && \
#     #./rover_v0.3.2 -workingDir "/home/david/Documents/GitHub/IaC/itau-cl/eks-tf-sandb/tf/root_module" -tfPath "/usr/bin/terraform"

# Real container 
FROM pythonbase as real-container
    
    ARG GLIBC_VERSION=2.34-r0
    ARG AWSCLI_VERSION=2.6.1

    # install glibc compatibility for alpine
    RUN apk --no-cache add \
            binutils \
            curl \
        && curl -sL https://alpine-pkgs.sgerrand.com/sgerrand.rsa.pub -o /etc/apk/keys/sgerrand.rsa.pub \
        && curl -sLO https://github.com/sgerrand/alpine-pkg-glibc/releases/download/${GLIBC_VERSION}/glibc-${GLIBC_VERSION}.apk \
        && curl -sLO https://github.com/sgerrand/alpine-pkg-glibc/releases/download/${GLIBC_VERSION}/glibc-bin-${GLIBC_VERSION}.apk \
        && curl -sLO https://github.com/sgerrand/alpine-pkg-glibc/releases/download/${GLIBC_VERSION}/glibc-i18n-${GLIBC_VERSION}.apk \
        && apk add --no-cache \
            glibc-${GLIBC_VERSION}.apk \
            glibc-bin-${GLIBC_VERSION}.apk \
            glibc-i18n-${GLIBC_VERSION}.apk \
        && /usr/glibc-compat/bin/localedef -i en_US -f UTF-8 en_US.UTF-8


    RUN wget "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -O "awscliv2.zip"
    RUN unzip awscliv2.zip
    RUN ./aws/install
    RUN alias aws="/usr/local/bin/aws"
    RUN aws --version
    
    RUN rm -rf /usr/local/aws-cli/v2/current/dist/awscli/examples glibc-*.apk 
    RUN find /usr/local/aws-cli/v2/current/dist/awscli/botocore/data -name examples-1.json -delete && apk --no-cache del binutils curl && rm -rf /var/cache/apk/*
    RUN rm -rf awscliv2.zip aws /usr/local/aws-cli/v2/current/dist/aws_completer /usr/local/aws-cli/v2/current/dist/awscli/data/ac.index

    RUN adduser user --disabled-password
    USER user
    WORKDIR /home/user
    ENV PATH=/home/user/bin:$PATH
    RUN echo "AWS VERSION" $(aws --version)

    # COPY from my own builds
    COPY --from=builder-disposable /salida /usr/local/bin/
    COPY --from=python-disposable /opt/venv /opt/venv  
    #COPY --from=go-disposable /salida /usr/local/bin

    # COPY from remote "original" builds
    COPY --from=aquasec/tfsec:latest /usr/bin/ /usr/local/bin
    COPY --from=hashicorp/terraform:light /bin/terraform /usr/local/bin
    COPY --from=snyk/driftctl /bin/driftctl /usr/local/bin
    COPY --from=infracost/infracost /usr/bin/infracost /usr/local/bin
    COPY --from=fugue/regula /bin/regula /usr/local/bin
    COPY --from=bitnami/git /opt/bitnami/git/bin/git /usr/local/bin
    
    # Make sure we use the virtualenv:
    ENV PATH="/opt/venv/bin:$PATH"
    ENV PATH="/home/${TERRAFORM_USER}/.local/bin:${PATH}"
    
    RUN echo "AWS VERSION: " $(aws --version) && \
        echo "TERRAFORM VERSION: "$(terraform --version) && \
        echo "TERRAFORM DOCS VERSION: "$(terraform-docs --version) && \
        echo "DRIFTCTL VERSION: "$(driftctl version) && \
        echo "INFRACOST VERSION: "$(infracost --version) && \
        echo "CHECKOV VERSION: "$(checkov -v) && \
        echo "TFSEC VERSION: "$(tfsec --version) && \
        echo "REGULA VERSION: "$(regula version) && \
        echo "GIT VERSION: " $(git version) && \
        echo "JQ VERSION: "$(jq --version)

    RUN which sleep
    ENTRYPOINT [ "/bin/sleep", "6000" ]