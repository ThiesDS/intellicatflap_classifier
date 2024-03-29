#!/bin/bash

# Set up correct environment
eval "$(conda shell.bash hook)"
conda deactivate
conda activate intellicatflap_classifier_applications

# Kill and/or remove running containers
docker kill tf_serving_cat_classification
docker rm tf_serving_cat_classification

# Spin up tf serving
docker run -d -p 8501:8501 \
  --name=tf_serving_cat_classification \
  -v $PWD/models/cat_classifier_v0_tobivscatflap/saved_model:/models/cat_classifier/1 \
  -e MODEL_NAME=cat_classifier \
  -t tensorflow/serving

# Run classification (path must end with /; destination: 'local' or 'gcs')
python src/main.py --gcs_path='2021/04/18/' --destination='local'