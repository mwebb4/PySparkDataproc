#!/bin/bash
PROJECT_ID="arctic-pad-357221"
REGION="us-central1"
BUCKET="arctic-pad-default"
FOLDER_NAME="flight_utils"
VERSION="1"
SVC_ACCT_NAME="svc-acct-art-reg"
DIST_FOLDER="dist"

echo "Cleaning build folder: $DIST_FOLDER"
rm -r $DIST_FOLDER
mkdir dist

echo "Configuring GCloud CLI..."
gcloud auth activate-service-account --key-file=.creds/$SVC_ACCT_NAME.json

echo "Building dist..."
mkdir .staging
cp -r ./src/$FOLDER_NAME ./.staging
pip install -r requirements.txt -t ./.staging
cd ./.staging && zip -x "*.git*" -x "*.DS_Store" -x "*.pyc" -x "*/*__pycache__*/" -x ".idea*" -r ../dist/deps.zip .
cd .. && cp ./src/main.py ./dist
gsutil cp -r ./dist gs://$BUCKET/$FOLDER_NAME/$VERSION

echo "Cleaning-up..."
rm -r ./.staging