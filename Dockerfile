FROM mcr.microsoft.com/azureml/openmpi3.1.2-ubuntu18.04

ENV AZUREML_CONDA_ENVIRONMENT_PATH /azureml-envs/torch-env

RUN apt-get update
RUN apt install -y build-essential
RUN apt-get install -y module-init-tools kmod
RUN apt install -y linux-headers-generic

# Install Nvidia driver
ENV BASE_URL https://us.download.nvidia.com/tesla
ENV DRIVER_VERSION 460.73.01
RUN curl -fSsl -O $BASE_URL/$DRIVER_VERSION/NVIDIA-Linux-x86_64-$DRIVER_VERSION.run
RUN sh NVIDIA-Linux-x86_64-$DRIVER_VERSION.run -s

# Installing and running Nvidia Fabric Manager
RUN apt-get install -y cuda-drivers-fabricmanager-460
RUN systemctl start nvidia-fabricmanager

# Create conda environment
RUN conda create -p $AZUREML_CONDA_ENVIRONMENT_PATH pytorch torchvision torchaudio cudatoolkit=11.1 -c pytorch -c nvidia

# Prepend path to AzureML conda environment
ENV PATH $AZUREML_CONDA_ENVIRONMENT_PATH/bin:$PATH

# Install pip dependencies
RUN pip install 'mxnet' \
                'easydict' \
                'wandb' \
                'scikit-learn' 

# This is needed for mpi to locate libpython
ENV LD_LIBRARY_PATH $AZUREML_CONDA_ENVIRONMENT_PATH/lib:$LD_LIBRARY_PATH
