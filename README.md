# iron-chart-hugo

Example repository to develop a Hugo-backed website and automatically publish to a Helm chart using security best practices on GitHub. Fork me!

[![Release](https://github.com/ironpeakservices/iron-chart-hugo/workflows/Release/badge.svg)](https://github.com/ironpeakservices/iron-chart-hugo/actions?query=workflow%3ARelease)

## Development

```shell
# this deploys as a helm chart to your default kubernetes context
% make

# see the pods being created
% kubectl get pods

# now edit the website source code to see it reload live!
```

## Debugging

```shell
# see what's holding up the Pod
% kubectl logs <the-pod-id>

# try to force redeploy the Chart
% make clean build up logs
```

## Releasing

1. Push your changes to `dev` or a feature branch.
2. Open a Pull Request and see your changes get linted, built and tested!
3. Merge to publish a new Helm Chart release.

## Usage

```shell
% helm repo add ironcharthugo https://${GITHUB_TOKEN}@raw.githubusercontent.com/ironpeakservices/iron-chart-hugo/helmrepo/
"iron-chart-hugo" has been added to your repositories

% helm install mychart ironcharthugo/iron-chart-hugo
```
