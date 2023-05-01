ARG BASE_IMAGE_VERSION=alpine-3.17
FROM mcr.microsoft.com/devcontainers/base:${BASE_IMAGE_VERSION} AS builder

ENV KUBE_LINTER_VERSION=0.6.2
ENV HELM_UNIT_TEST_VERSION=0.3.2

RUN apk add --no-cache curl openssl ca-certificates && \
    wget https://github.com/stackrox/kube-linter/releases/download/v$KUBE_LINTER_VERSION/kube-linter-linux.tar.gz && \
    tar -xzf kube-linter-linux.tar.gz && mv kube-linter /usr/local/bin/ && \
    curl https://raw.githubusercontent.com/helm/helm/master/scripts/get-helm-3 | sh && \
    helm plugin install https://github.com/helm-unittest/helm-unittest.git --version v$HELM_UNIT_TEST_VERSION && \
    rm -rf /var/cache/apk/* /root/.cache /kube-linter-linux.tar.gz

FROM mcr.microsoft.com/devcontainers/base:${BASE_IMAGE_VERSION}

ARG USERNAME=nonroot
ARG USER_UID=1000
ARG USER_GID=$USER_UID

# Create the user
RUN groupadd --gid $USER_GID $USERNAME \
    && useradd --uid $USER_UID --gid $USER_GID -m $USERNAME

ENV HELM_PLUGINS /workspaces/.local/share/helm/plugins

COPY --from=builder /usr/local/bin/kube-linter /usr/local/bin/kube-linter
COPY --from=builder /usr/local/bin/helm /usr/local/bin/helm
COPY --from=builder /root/.local/share/helm/plugins $HELM_PLUGINS

RUN chown -R $USERNAME:$USERNAME /home/$USERNAME
USER $USERNAME
