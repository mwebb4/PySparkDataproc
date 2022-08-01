#!/bin/bash
PROJECT_ID="arctic-pad-357221"
FOLDER_NAME="flight_utils"
REPOSITORY="python-repo-dev"
REGION="us-central1"
SVC_ACCT_NAME="svc-acct-art-reg"
DIST_FOLDER="dist"

echo "Cleaning build folder: $DIST_FOLDER"
rm -r $DIST_FOLDER


echo "Configuring GCloud CLI..."

gcloud auth activate-service-account --key-file=.creds/$SVC_ACCT.json

gcloud --quiet config set project $PROJECT_ID

gcloud --quiet config set artifacts/repository $REPOSITORY

gcloud --quiet config set artifacts/location $REGION


echo "Generating credentials for $REPOSITORY..."
resp=${gcloud artifacts print-settings python --json-key=.creds/$SVC_ACCT.json}
rightpart=${resp##*password\: }
token=${rightpart%%\# Insert *}


echo "Setting-up pip..."
python3 -m pip install --upgrade build
pip install twine


echo "Staging files..."
mkdir .staging
cp -r $FOLDER_NAME .staging/$FOLDER_NAME
cp pyproject.toml .staging/


echo "Building dist..."
python3 -m build .staging/ -o $DIST_FOLDER/


echo "Uploading to $REPOSITORY..."
python3 -m twine upload $DIST_FOLDER/* \
    -r $REPOSITORY \
    --repository-url "https://$REGION-python.pkg.dev/$PROJECT_ID/$REPOSITORY" \
    --config-file .pypirc \
    --non-interactive\
    --username "_json_key_base64" \
    --password $token \
    --skip-existing \
    --verbose


echo "Cleaning-up..."
rm .staging -r