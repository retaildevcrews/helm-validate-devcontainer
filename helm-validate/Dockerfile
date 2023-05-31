# Using an argument to set the base image version
ARG BASE_IMAGE_VERSION=alpine-3.17

# Build stage
FROM mcr.microsoft.com/devcontainers/base:${BASE_IMAGE_VERSION} AS builder

# Setting environment variables for versions
ENV KUBE_LINTER_VERSION=0.6.2 \
    HELM_UNIT_TEST_VERSION=0.3.2 \
    KUBECONFORM_VERSION=0.6.1

# Installing necessary tools and plugins
RUN apk add --no-cache curl openssl ca-certificates && \
    wget https://github.com/stackrox/kube-linter/releases/download/v$KUBE_LINTER_VERSION/kube-linter-linux.tar.gz && \
    tar -xzf kube-linter-linux.tar.gz && mv kube-linter /usr/local/bin/ && \
    curl https://raw.githubusercontent.com/helm/helm/master/scripts/get-helm-3 | sh && \
    helm plugin install https://github.com/helm-unittest/helm-unittest.git --version v$HELM_UNIT_TEST_VERSION && \
    wget https://github.com/yannh/kubeconform/releases/download/v$KUBECONFORM_VERSION/kubeconform-linux-amd64.tar.gz && \
    tar -xzf kubeconform-linux-amd64.tar.gz && mv kubeconform /usr/local/bin/ && \
    rm -rf /var/cache/apk/* /root/.cache kube-linter* kubeconform*

# Release stage
FROM mcr.microsoft.com/devcontainers/base:${BASE_IMAGE_VERSION}

# Defining arguments and environment variables
ARG USERNAME=vscode
ENV HELM_PLUGINS /workspaces/.local/share/helm/plugins

# Copying necessary files and plugins to /usr/local/bin
COPY --from=builder /usr/local/bin/kube-linter /usr/local/bin/kubeconform /usr/local/bin/helm /usr/local/bin/
COPY --from=builder /root/.local/share/helm/plugins $HELM_PLUGINS

# Changing ownership and setting user
RUN chown -R $USERNAME:$USERNAME /home/$USERNAME
USER $USERNAME
