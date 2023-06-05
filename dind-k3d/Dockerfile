# Build stage
FROM mcr.microsoft.com/devcontainers/base:debian as dind

# user args
# some base images require specific values
ARG USERNAME=vscode
ARG USER_UID=1000
ARG USER_GID=$USER_UID

# configure apt-get
ENV DEBIAN_FRONTEND noninteractive
ENV PATH $PATH:/usr/local/go/bin:/home/${USERNAME}/go/bin:/home/${USERNAME}/.local/bin
ENV COMPlus_EnableDiagnostics=0
ENV COMPlus_EnableWriteXorExecute=0

RUN mkdir -p /home/${USERNAME}/.local/bin && \
    mkdir -p /home/${USERNAME}/.ssh && \
    mkdir -p /home/${USERNAME}/.oh-my-zsh/completions && \
    mkdir -p /home/${USERNAME}/go/bin && \
    chsh --shell /bin/zsh vscode

# copy the stup scripts to the image
COPY dind-k3d/scripts/*.sh /scripts/

RUN apt-get update && \
    /bin/bash /scripts/common-tools.sh && \
    /bin/bash /scripts/docker-in-docker-debian.sh && \
    /bin/bash /scripts/kubectl-helm-debian.sh && \
    /bin/bash /scripts/dind-debian.sh && \
    chown -R ${USERNAME}:${USERNAME} /home/${USERNAME}

WORKDIR /home/${USERNAME}
# USER ${USERNAME}

USER root

# docker pipe
VOLUME [ "/var/lib/docker" ]

# Setting the ENTRYPOINT to docker-init.sh will start up the Docker Engine
# inside the container "overrideCommand": false is set in devcontainer.json.
# The script will also execute CMD if you need to alter startup behaviors.
ENTRYPOINT [ "/usr/local/share/docker-init.sh" ]
CMD [ "sleep", "infinity" ]

### Build k3d image from Docker-in-Docker
FROM dind as k3d

ARG USERNAME=vscode

ENV DEBIAN_FRONTEND noninteractive
ENV PATH $PATH:/usr/local/go/bin:/usr/local/istio/bin:/home/${USERNAME}/go/bin:/home/${USERNAME}/.local/bin

# install kind / k3d
RUN /bin/bash /scripts/kind-k3d-debian.sh && \
    # change ownership of the home directory
    chown -R ${USERNAME}:${USERNAME} /home/${USERNAME} && \
    # update the container
    apt-get update && \
    apt-get upgrade -y && \
    apt-get autoremove -y && \
    apt-get clean -y