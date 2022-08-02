#!/bin/sh
PROJECT_ID="arctic-pad-357221"
LOG_CLUSTER="arctic-pad-dprc-clst-01"
REGION="us-central1"
BUCKET="arctic-pad-dproc-jobs"
MAIN_PYTHON_FILE="main.py"
CONTAINER_NAME="flights-train-dproc"
CONTAINER_TAG="1.2"
IMAGE_ID="gcr.io/$PROJECT_ID/$CONTAINER_NAME/$CONTAINER_TAG"
SVC_ACCT="svcacct-dataproc"


echo "Configuring GCloud..."
gcloud auth activate-service-account "$SVC_ACCT@$PROJECT_ID.iam.gserviceaccount.com" --key-file ./.creds/$SVC_ACCT.json


echo "Submitting job to cluster..."
gcloud dataproc batches submit pyspark ./src/$MAIN_PYTHON_FILE \
    --region=$REGION \
    --project=$PROJECT_ID \
    --container-image=$IMAGE_ID \
    --deps-bucket=$BUCKET \
    --service-account="$SVC_ACCT@$PROJECT_ID.iam.gserviceaccount.com" \
    -- \
    --word="A WORD?!"