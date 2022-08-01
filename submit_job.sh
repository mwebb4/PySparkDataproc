#!/bin/sh
PROJECT_ID="arctic-pad-357221"
CLUSTER="arctic-pad-dprc-clst-01"
REGION="us-central1"
DATA_BUCKET="arctic-pad-default"
SCRIPT_BUCKET="arctic-pad-dproc-jobs"
FAT_JAR_NAME="silly-model-fatjar-0.1.0"
FAT_JAR_LOCAL_PATH="./target/scala-2.12/$FAT_JAR_NAME.jar"
MODEL_NAME="SillyDemoModel"
MAIN_CLASS="main.Main"
FAT_JAR_URI="gs://$SCRIPT_BUCKET/$MODEL_NAME/$FAT_JAR_NAME.jar"
DATA_URI="gs://$DATA_BUCKET/data.csv"
FEATURE_NAMES="x_0,x_1,x_2,x_3,x_4"
TARGET_VAR_NAME="y"

echo "Checking for previous jar in bucket..."
gsutil -q stat $FAT_JAR_URI
status=$?

if [[ $status == 0 ]]; then
  echo "Previous jar file found."
  gsutil rm $FAT_JAR_URI
else
  echo "No previous version found."
fi

echo "Uploading latest version from $FAT_JAR_LOCAL_PATH."
gsutil cp target/scala-2.12/$FAT_JAR_NAME.jar \
    $FAT_JAR_URI$file_path

echo "Submitting job to cluster..."
gcloud dataproc jobs submit spark \
    --cluster=$CLUSTER \
    --class=$MAIN_CLASS \
    --jars=$FAT_JAR_URI \
    --region=$REGION \
    --project=$PROJECT_ID \
    -- \
    --datapath=$DATA_URI \
    --features=$FEATURE_NAMES \
    --target=$TARGET_VAR_NAME

