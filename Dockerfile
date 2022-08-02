# Debian 11 is recommended.
FROM debian:11-slim

ARG ADD_MOD_DIR="flight_utils"
ARG STG_DIR=".staging"

# Suppress interactive prompts
ENV DEBIAN_FRONTEND=noninteractive

# (Required) Install utilities required by Spark scripts.
RUN apt update && apt install -y procps tini curl

# (Optional) Add extra jars.
ENV SPARK_EXTRA_JARS_DIR=/opt/spark/jars/
ENV SPARK_EXTRA_CLASSPATH='/opt/spark/jars/*'
RUN mkdir -p "${SPARK_EXTRA_JARS_DIR}"
COPY ${STG_DIR}/spark-bigquery-with-dependencies_2.12-0.22.2.jar "${SPARK_EXTRA_JARS_DIR}"

# (Optional) Install and configure Miniconda3.
ENV CONDA_HOME=/opt/miniconda3
ENV PYSPARK_PYTHON=${CONDA_HOME}/bin/python
ENV PATH=${CONDA_HOME}/bin:${PATH}
COPY ${STG_DIR}/miniconda.sh .
RUN bash miniconda.sh -b -p /opt/miniconda3 \
    && ${CONDA_HOME}/bin/conda config --system --set always_yes True \
    && ${CONDA_HOME}/bin/conda config --system --set auto_update_conda False \
    && ${CONDA_HOME}/bin/conda config --system --prepend channels conda-forge \
    && ${CONDA_HOME}/bin/conda config --system --set channel_priority strict

# (Optional) Install Conda packages.
RUN ${CONDA_HOME}/bin/conda install mamba -n base -c conda-forge \
    && ${CONDA_HOME}/bin/mamba install \
    conda \
    cython \
    fastavro \
    fastparquet \
    gcsfs \
    google-cloud-bigquery-storage \
    google-cloud-bigquery[pandas] \
    google-cloud-bigtable \
    google-cloud-container \
    google-cloud-datacatalog \
    google-cloud-dataproc \
    google-cloud-datastore \
    google-cloud-language \
    google-cloud-logging \
    google-cloud-monitoring \
    google-cloud-pubsub \
    google-cloud-redis \
    google-cloud-spanner \
    google-cloud-speech \
    google-cloud-storage \
    google-cloud-texttospeech \
    google-cloud-translate \
    google-cloud-vision \
    koalas \
    matplotlib \
    nltk \
    numba \
    numpy \
    openblas \
    orc \
    pandas \
    pyarrow \
    pysal \
    pytables \
    python \
    regex \
    requests \
    rtree \
    scikit-image \
    scikit-learn \
    scipy \
    seaborn \
    sqlalchemy \
    sympy \
    virtualenv

# (Optional) Add extra Python modules.
ENV PYTHONPATH=/opt/python/packages
RUN mkdir -p "${PYTHONPATH}"
COPY src/${ADD_MOD_DIR} "${PYTHONPATH}/${ADD_MOD_DIR}"


# (Required) Create the 'spark' group/user.
# The GID and UID must be 1099. Home directory is required.
RUN groupadd -g 1099 spark
RUN useradd -u 1099 -g 1099 -d /home/spark -m spark
USER spark
