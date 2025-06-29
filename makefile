NAMESPACE ?= monitoring
RELEASE_NAME ?= grafana
CHART_REPO ?= grafana
CHART_NAME ?= grafana
CHART_VERSION ?= 9.2.7
VALUES_FILE ?=grafana-values.yaml
EXTRA_ARGS ?=

.PHONY: grafana-upgrade

grafana-upgrade:
	@echo "Upgrading Grafana Helm chart to version $(CHART_VERSION)..."
	helm repo add $(CHART_REPO) https://grafana.github.io/helm-charts || true
	helm repo update
	helm upgrade --install $(RELEASE_NAME) $(CHART_REPO)/$(CHART_NAME) \
		--namespace $(NAMESPACE) \
		--create-namespace \
		--version $(CHART_VERSION) \
		--values $(VALUES_FILE) \
		--set persistence.initChownData=false
		--set extraInitContainers={} \
		--set-string 'persistence.securityContext.runAsUser=' \
		--set-string 'persistence.securityContext.fsGroup=' \
		--force
