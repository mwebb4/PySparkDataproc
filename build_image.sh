#!/bin/sh
PROJECT_ID="arctic-pad-357221"
REGION="us-central1"
SVC_ACCT="svc-acct-art-reg"
MAIN_PYTHON_FILE="main.py"
CONTAINER_NAME="flights-train-dproc"
CONTAINER_TAG="1.2"
IMAGE_ID="gcr.io/$PROJECT_ID/$CONTAINER_NAME/$CONTAINER_TAG"
STG_DIR=".staging"


echo "Configuring GCloud..."
gcloud auth activate-service-account "$SVC_ACCT@$PROJECT_ID.iam.gserviceaccount.com" --key-file ./.creds/$SVC_ACCT.json

gcloud auth configure-docker

echo "Downloading BQ jar..."
mkdir $STG_DIR
gsutil cp \
  gs://spark-lib/bigquery/spark-bigquery-with-dependencies_2.12-0.22.2.jar $STG_DIR/

echo "Downloading Miniconda installer..."
curl https://repo.anaconda.com/miniconda/Miniconda3-py39_4.10.3-Linux-x86_64.sh -o $STG_DIR/miniconda.sh

echo "Builing image..."
docker build -t $IMAGE_ID .

echo "Pushing image..."
docker push $IMAGE_ID

echo "Cleaning-up..."
rm -r $STG_DIR