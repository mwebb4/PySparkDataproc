#!/bin/sh
PROJECT_ID="arctic-pad-357221"
REGION="us-central1"
CODE_BUCKET="arctic-pad-default"
CODE_FOLDER="flight_utils"
VERSION="1"
DEPS_BUCKET="arctic-pad-dproc-jobs"
MAIN_PYTHON_FILE="main.py"
IMAGE_ID="gcr.io/$PROJECT_ID/$CONTAINER_NAME/$CONTAINER_TAG"
SVC_ACCT="svcacct-dataproc"


echo "Configuring GCloud..."
gcloud auth activate-service-account "$SVC_ACCT@$PROJECT_ID.iam.gserviceaccount.com" --key-file ./.creds/$SVC_ACCT.json


echo "Submitting job to cluster..."
gcloud dataproc batches submit pyspark "gs://$CODE_BUCKET/$CODE_FOLDER/$VERSION/dist/$MAIN_PYTHON_FILE" \
    --py-files="gs://$CODE_BUCKET/$CODE_FOLDER/$VERSION//dist/deps.zip" \
    --region=$REGION \
    --project=$PROJECT_ID \
    --deps-bucket=$DEPS_BUCKET \
    --service-account="$SVC_ACCT@$PROJECT_ID.iam.gserviceaccount.com" \
    -- \
    --word="A WORD?!"