update-config:
	kubectl create configmap config --from-file=config.yaml=./config/config.yaml --dry-run=client -o yaml | kubectl -n prow replace configmap config -f -

update-plugins:
	kubectl create configmap plugins --from-file=plugins.yaml=./config/plugins.yaml --dry-run=client -o yaml | kubectl -n prow replace configmap plugins -f -

deploy-prow:
	# kubectl apply --server-side=true -f ./cluster/prowjob_crd/prowjob_customresourcedefinition.yaml
	kubectl apply -f ./cluster/starter/starter-nordix-gcs.yaml

undeploy-prow:
	kubectl delete -f ./cluster/starter/starter-nordix-gcs.yaml

.PHONY: update-config update-plugins deploy-prow