FROM mcr.microsoft.com/azureml/openmpi4.1.0-cuda11.0.3-cudnn8-ubuntu18.04:20210615.v1

#FROM nvidia/driver:460.73.01-ubuntu18.04
ENV AZUREML_CONDA_ENVIRONMENT_PATH /azureml-envs/torch-env

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
