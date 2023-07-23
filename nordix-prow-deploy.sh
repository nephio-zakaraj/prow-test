kubectl create clusterrolebinding cluster-admin-binding --clusterrole cluster-admin --user $(gcloud config get-value account)

kubectl create ns prow

kubectl create ns test-pods

kubectl create secret -n prow generic hmac-token --from-file=hmac=tokens/secret

kubectl create secret -n prow generic github-token --from-file=cert=tokens/prow-zakaraj-bot.2023-06-22.private-key.pem --from-literal=appid=350959

kubectl create secret -n test-pods generic github-token --from-file=cert=tokens/prow-zakaraj-bot.2023-06-22.private-key.pem --from-literal=appid=350959

gcloud iam service-accounts create prow-gcs-publisher

identifier="$(gcloud iam service-accounts list --filter 'name:prow-gcs-publisher' --format 'value(email)')"

# Create bucket for prow 
gsutil mb -l eu gs://nephio-prow-bucket # step 2

gsutil iam ch allUsers:objectViewer gs://nephio-prow-bucket # step 3

gsutil iam ch "serviceAccount:${identifier}:objectAdmin" gs://nephio-prow-bucket # step 4

gcloud iam service-accounts keys create --iam-account "${identifier}" service-account.json # step 5

kubectl -n test-pods create secret generic gcs-credentials --from-file=service-account.json # step 6

kubectl -n prow create secret generic gcs-credentials --from-file=service-account.json # this secret is also needed by deployments in the prow namespace

kubectl apply --server-side=true -f prow/cluster/prowjob_crd/prowjob_customresourcedefinition.yaml