# Helm Validate - Devcontainer

This repository contains a development container (devcontainer) to streamline the process of validating and testing Helm charts. The devcontainer is pre-configured with essential tools, such as `kube-linter` for linting Kubernetes resources and `helm unittest` for running Helm chart unit tests, and `kubeconform` for validating Kubernetes resources. K3D is then used to deploy a light-weight cluster to run the Helm chart.

## Table of Contents

- [Prerequisites](#prerequisites)
- [Getting Started](#getting-started)
- [Using the Devcontainer](#using-the-devcontainer)
  - [Linting with Kube Linter](#linting-with-kube-linter)
  - [Running Helm Unit Tests](#running-helm-unit-tests)
  - [Validating with Kubeconform](#validating-with-kubeconform)
  - [Docker in Docker with K3D](#docker-in-docker-with-k3d)
- [Customizing the Devcontainer](#customizing-the-devcontainer)
- [Using GitHub Codespaces](#using-github-codespaces)
- [Contributing](#contributing)
- [License](#license)

## Prerequisites

To use this devcontainer, you'll need the following tools installed on your local machine. Alternatively, you can use it as a Codespace, as mentioned in the section below:

- [Docker](https://docs.docker.com/get-docker/)
- [Visual Studio Code](https://code.visualstudio.com/download)
- [Dev Containers extension](https://marketplace.visualstudio.com/items?itemName=ms-vscode-remote.remote-containers) for Visual Studio Code

## Getting Started

1. Clone this repository:

```bash

git clone https://github.com/retaildevcrews/helm-validate-devcontainer.git
cd helm-validate-devcontainer

```

2. Open the repository in Visual Studio Code.

3. Configure the devcontainer.json at the root .devcontainer to specify which image to use. A published image or a local Dockerfile can be targeted.

4. Press `F1` and type `Dev Containers: Reopen in Container`, then press `Enter`. This will build the Docker container and open the repository inside the container.

5. Wait for the container to build and start. Once it's ready, you'll be able to use the pre-configured tools for validating and testing Helm charts.

## Using the Devcontainer

To utilize Kubelinter, Helm Unittest, or Kubeconform, the helm-validate folder contains the Dockerfile that will build the image with these tools. To utilize K3D in docker-in-docker, the folder dind-k3d contains the Dockerfile that will build the image needed.

### Linting with Kube Linter

Kube Linter is a static analysis tool that helps ensure your Kubernetes resources follow best practices. By analyzing your Kubernetes manifests, Kube Linter provides suggestions and warnings to help you maintain a secure, efficient, and stable cluster.

To lint your Kubernetes resources using `kube-linter`, run the following command:

```bash
kube-linter lint <path-to-your-helm-chart>
```

`kube-linter` will analyze your resources and provide suggestions and warnings based on best practices. This can include detecting potential security risks, identifying deprecated API versions, and suggesting resource limits and requests.

In the `samples` directory, you will find a Helm chart to validate and a custom configuration for kube-linter. You can run this by executing the following command: 

```bash
kube-linter lint samples/chart/ngsa --config samples/kube-lint/config.yaml
```

This command will lint the `ngsa` Helm chart in the `samples/chart` directory using the custom configuration file located at `samples/kube-lint/config.yaml`.

Kube Linter supports advanced configurations, allowing you to customize its behavior to better suit your specific needs. You can configure the tool to ignore certain checks, modify the severity of specific issues, or add custom checks. To learn more about configuring Kube Linter, refer to the [documentation](https://docs.kubelinter.io/#/configuring-kubelinter).


### Running Helm Unit Tests

To run unit tests for your Helm charts using the `helm unittest` plugin, execute the following command:

``` bash
helm unittest samples/chart/ngsa/
```

This command will run all the unit tests defined in the `_test.yaml` files within your Helm chart's `tests` directory. For more information how how to write unit tests, please refer to the [helm-unittest repo](https://github.com/helm-unittest/helm-unittest)


### Validating with Kubeconform

Kubeconform is a tool that validates Kubernetes resources against the Kubernetes OpenAPI specification. It helps ensure your resources are compliant with the Kubernetes API, providing warnings and errors for non-compliant configurations.

To validate your Kubernetes resources using `kubeconform`, run the following command:

```bash
kubeconform -strict <path-to-your-kubernetes-manifests>
```

Kubeconform is primarily designed to validate raw Kubernetes YAML or JSON files against the Kubernetes OpenAPI specification. However, Helm charts aren't raw Kubernetes resources; they're templates that generate Kubernetes resources.

If you want to validate a Helm chart with Kubeconform, you would first need to render your Helm chart to raw Kubernetes resources. You can do this using the `helm template` command, which will output the Kubernetes resources as YAML to the console. This output can then be validated using Kubeconform.

You can achieve this with the following command:

```bash
helm template samples/chart/ngsa| kubeconform -strict -
```

It's important to note that you may encounter an error with the previous command regarding a missing schema for ServiceMonitor. This occurs because Custom Resource Definitions (CRDs) are not native Kubernetes objects and, therefore, are not included in the default schema. If your CRDs are present in [Datree's CRDs-catalog](https://github.com/datreeio/CRDs-catalog), you can specify this project as an additional registry for schema lookup.

```bash
# Look in the CRDs-catalog for the desired schema/s
helm template samples/chart/ngsa | \
kubeconform \
  -strict \
  -schema-location default \
  -schema-location 'https://raw.githubusercontent.com/datreeio/CRDs-catalog/main/{{.Group}}/{{.ResourceKind}}_{{.ResourceAPIVersion}}.json'
```

### Docker in Docker with K3D

K3D is a lightweight wrapper that runs K3S (lightweight kubernetes) in Docker. It allows the creation of single- and multi-node clusters [K3D](https://k3d.io/v5.5.1/). In order to utilize K3D in a dev container, the concept of docker-in-docker is needed. The docker file and scripts in the dind-k3d folder is based on this project [Docker images for Codespaces](https://github.com/cse-labs/codespaces-images).

Here is an example of using k3d to create a cluster and helm install ngsa in a container. Prometheus is needed as a prerequisite for ngsa and is installed first.

```bash
# Create k3d cluster
k3d cluster create
kubectl config use-context k3d-k3s-default

# Install prometheus for ngsa
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm install -f /workspaces/helm-validate-devcontainer/samples/prometheus/values.yaml prometheus prometheus-community/kube-prometheus-stack

# Wait for prometheus to be running
kubectl wait --for=condition=Ready --timeout=30s pod -l app.kubernetes.io/name=prometheus
kubectl get pods

# Install ngsa
helm install ngsa /workspaces/helm-validate-devcontainer/samples/chart/ngsa

# Wait for ngsa to be running
kubectl wait --for=condition=Ready --timeout=30s pod -l app=ngsa
kubectl get pods
```

## Customizing the Devcontainer

To customize the devcontainer, modify the `.devcontainer/devcontainer.json`, `dind-k3d/Dockerfile`, and `helm-validate/Dockerfile` file as needed. For example, you can add new tools or change the base image in the dockerfiles. You can also specify which local dockerfile to use as well as a published image in the devcontainer.json.

After making changes, rebuild the container by pressing `F1`, typing `Remote-Containers: Rebuild Container`, and pressing `Enter`.

## Github workflows

The main purpose for this repo is to test all the ideas outlined above in a Github workflow. A workflow is a configurable automated process that will run one or multiple sets of tasks defined as jobs. It can be triggered manually, a defined schedule, or a repository event. Customers can leverage this implementation to automate the validation of their helm chart cluster add-ons. Github workflow documentation can be referred here [Github workflows](https://docs.github.com/en/actions/using-workflows/about-workflows).

### Devcontainer Build

The devcontainer-build workflow builds the helm-validate image and pushes it to a pre-determined container registry. Currently, it is pointing to `ghcr.io/joaquinrz/helmv-devcontainer:latest`.

### Integration

The integration workflow utilizes the pre-built image `ghcr.io/joaquinrz/helmv-devcontainer:latest` for helm validation and `ghcr.io/nguyena2/friendlyfiesta` for dind-k3d chart deployment. 

By default, workflows will target the `devcontainer.json` at the root level. However, workflows can utilize multiple devcontainer configs by specifying a subfolder and utilizing the folder structure as set up in this project. This allows for multiple images to be built with only the necessary tools as required, keeping the image size to a minimum. 

Caching `cacheFrom:...` the image allows the workflow to re-use downloaded images in the workflow, reducing the overall time for the workflow to run and practicing sustainability programming.

```bash
name: Run Kube Linter
  id: helm-lint
  uses: devcontainers/ci@v0.3
  with:
    subFolder: helm-validate
    cacheFrom: ghcr.io/joaquinrz/helmv-devcontainer
    push: never
    runCmd: |
        kube-linter lint /workspaces/helm-validate-devcontainer/samples/chart/ngsa
```

## Using GitHub Codespaces

This devcontainer is also available as a GitHub Codespace. To use it in a Codespace, simply open the repository in a new Codespace, and GitHub will automatically build and launch the container with all the pre-configured tools for validating and testing Helm charts. For more information on using GitHub Codespaces, please refer to the [official documentation](https://docs.github.com/en/codespaces).

## Contributing

Contributions to this repository are welcome! To contribute, please open a pull request with a description of your changes.

## License

This project is licensed under the [MIT License](LICENSE).
