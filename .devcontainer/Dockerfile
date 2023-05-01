FROM mcr.microsoft.com/devcontainers/base:alpine-3.17

# some images require specific values
ARG USERNAME=vscode

# set the versions of tools
ENV KUBE_LINTER_VERSION=0.6.2
ENV HELM_UNIT_TEST_VERSION=0.3.2

RUN chown -R $USERNAME:$USERNAME /home/$USERNAME

RUN wget https://github.com/stackrox/kube-linter/releases/download/v$KUBE_LINTER_VERSION/kube-linter-linux.tar.gz && \
    tar -xzf kube-linter-linux.tar.gz && mv kube-linter /usr/local/bin/ && rm kube-linter-linux.tar.gz &&\
    apk add --update --no-cache curl openssl ca-certificates && \
    curl https://raw.githubusercontent.com/helm/helm/master/scripts/get-helm-3 | sh && sleep 120 && \
    helm plugin install https://github.com/helm-unittest/helm-unittest.git --version v$HELM_UNIT_TEST_VERSION

