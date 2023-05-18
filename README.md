# Helm Validate - Devcontainer

This repository contains a development container (devcontainer) to streamline the process of validating and testing Helm charts. The devcontainer is pre-configured with essential tools, such as `kube-linter` for linting Kubernetes resources and `helm unittest` for running Helm chart unit tests, and `kubeconform` for validating Kubernetes resources.

## Table of Contents

- [Prerequisites](#prerequisites)
- [Getting Started](#getting-started)
- [Using the Devcontainer](#using-the-devcontainer)
  - [Linting with Kube Linter](#linting-with-kube-linter)
  - [Running Helm Unit Tests](#running-helm-unit-tests)
  - [Validating with Kubeconform](#validating-with-kubeconform)
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

git clone https://github.com/joaquinrz/helm-validate-devcontainer.git
cd helm-chart-validation-devcontainer

```

2. Open the repository in Visual Studio Code.

3. Press `F1` and type `Dev Containers: Reopen in Container`, then press `Enter`. This will build the Docker container and open the repository inside the container.

4. Wait for the container to build and start. Once it's ready, you'll be able to use the pre-configured tools for validating and testing Helm charts.

## Using the Devcontainer

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
helm unittest <path-to-your-helm-chart>
```

This command will run all the unit tests defined in the `_test.yaml` files within your Helm chart's `tests` directory.


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

It's important to note that you may encounter an error with the previous command regarding a missing schema for ServiceMonitor. This occurs because Custom Resources (CRs) are not native Kubernetes objects and, therefore, are not included in the default schema. If your CRs are present in [Datree's CRDs-catalog](https://github.com/datreeio/CRDs-catalog), you can specify this project as an additional registry for schema lookup.

```bash
# Look in the CRDs-catalog for the desired schema/s
helm template samples/chart/ngsa | \
kubeconform \
  -strict \
  -schema-location default \
  -schema-location 'https://raw.githubusercontent.com/datreeio/CRDs-catalog/main/{{.Group}}/{{.ResourceKind}}_{{.ResourceAPIVersion}}.json' \
  -
```


## Customizing the Devcontainer

To customize the devcontainer, modify the `.devcontainer/Dockerfile` and `.devcontainer/devcontainer.json` files as needed. For example, you can add new tools or change the base image.

After making changes, rebuild the container by pressing `F1`, typing `Remote-Containers: Rebuild Container`, and pressing `Enter`.

## Using GitHub Codespaces

This devcontainer is also available as a GitHub Codespace. To use it in a Codespace, simply open the repository in a new Codespace, and GitHub will automatically build and launch the container with all the pre-configured tools for validating and testing Helm charts. For more information on using GitHub Codespaces, please refer to the [official documentation](https://docs.github.com/en/codespaces).


## Contributing

Contributions to this repository are welcome! To contribute, please open a pull request with a description of your changes.

## License

This project is licensed under the [MIT License](LICENSE).
