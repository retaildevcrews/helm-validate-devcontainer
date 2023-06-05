# Build stage
FROM mcr.microsoft.com/vscode/devcontainers/dotnet as dind

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

RUN echo ls
# copy the stup scripts to the image
COPY ./dind-k3d/scripts/*.sh /scripts/

RUN apt-get update
RUN apt-get -y install --no-install-recommends apt-utils dialog apt-transport-https ca-certificates curl wget

RUN /bin/bash /scripts/docker-in-docker-debian.sh
RUN /bin/bash /scripts/kubectl-helm-debian.sh
RUN /bin/bash /scripts/dind-debian.sh

# Changing ownership and setting user
RUN chown -R ${USERNAME}:${USERNAME} /home/${USERNAME}

WORKDIR /home/${USERNAME}
USER ${USERNAME}

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
RUN /bin/bash /scripts/kind-k3d-debian.sh

# change ownership of the home directory
RUN chown -R ${USERNAME}:${USERNAME} /home/${USERNAME}

# customize first run message
RUN echo "👋 Welcome to Codespaces! You are on a custom image defined in your devcontainer.json file.\n" > /usr/local/etc/vscode-dev-containers/first-run-notice.txt && \
    echo "🔍 To explore VS Code to its fullest, search using the Command Palette (Cmd/Ctrl + Shift + P)\n" >> /usr/local/etc/vscode-dev-containers/first-run-notice.txt && \
    echo "👋 Welcome to the k3d Codespaces image\n" >> /usr/local/etc/vscode-dev-containers/first-run-notice.txt

# update the container
RUN apt-get update
RUN apt-get upgrade -y
RUN apt-get autoremove -y && \
    apt-get clean -y