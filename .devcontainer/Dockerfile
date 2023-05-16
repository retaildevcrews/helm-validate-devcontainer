ARG BASE_IMAGE_VERSION=alpine-3.17
FROM mcr.microsoft.com/devcontainers/base:${BASE_IMAGE_VERSION} AS builder

ENV KUBE_LINTER_VERSION=0.6.2
ENV HELM_UNIT_TEST_VERSION=0.3.2
ENV KUBECONFORM_VERSION=0.6.1

RUN apk add --no-cache curl openssl ca-certificates && \
    wget https://github.com/stackrox/kube-linter/releases/download/v$KUBE_LINTER_VERSION/kube-linter-linux.tar.gz && \
    tar -xzf kube-linter-linux.tar.gz && mv kube-linter /usr/local/bin/ && \
    curl https://raw.githubusercontent.com/helm/helm/master/scripts/get-helm-3 | sh && \
    helm plugin install https://github.com/helm-unittest/helm-unittest.git --version v$HELM_UNIT_TEST_VERSION && \
    wget https://github.com/yannh/kubeconform/releases/download/v$KUBECONFORM_VERSION/kubeconform-linux-amd64.tar.gz && \
    tar -xzf kubeconform-linux-amd64.tar.gz && mv kubeconform /usr/local/bin/ && \
    rm -rf /var/cache/apk/* /root/.cache kube-linter* kubeconform*

FROM mcr.microsoft.com/devcontainers/base:${BASE_IMAGE_VERSION}

ARG USERNAME=vscode
# ARG GROUPNAME=$USERNAME

# RUN addgroup -S $GROUPNAME && adduser -D -G $GROUPNAME $USERNAME

ENV HELM_PLUGINS /workspaces/.local/share/helm/plugins

COPY --from=builder /usr/local/bin/kube-linter /usr/local/bin/kube-linter
COPY --from=builder /usr/local/bin/kubeconform /usr/local/bin/kubeconform
COPY --from=builder /usr/local/bin/helm /usr/local/bin/helm
COPY --from=builder /root/.local/share/helm/plugins $HELM_PLUGINS

RUN chown -R $USERNAME:$USERNAME /home/$USERNAME
USER $USERNAME
