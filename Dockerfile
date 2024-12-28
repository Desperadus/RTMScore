FROM nvidia/cuda:12.6.3-cudnn-runtime-ubuntu24.04

# Set the working directory in the container
WORKDIR /app

# Install system dependencies
RUN apt-get update && apt-get install -y \
    wget \
    git \
    vim \
    libgl1 \
    libxext6 \
    libsm6 \
    libxrender1 \
    libfontconfig1  \
    && rm -rf /var/lib/apt/lists/*

# Copy the environment file
COPY environment.yml .

# Install conda
RUN wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh -O miniconda.sh
RUN bash miniconda.sh -b -p /opt/conda
ENV PATH="/opt/conda/bin:${PATH}"

# Create and activate the conda environment
RUN conda init bash && conda env create -f environment.yml
ENV CONDA_DEFAULT_ENV=stocking
RUN echo "conda activate rtmscore" >> ~/.bashrc

# Copy the project files into the container
COPY . .
# Set environment variable for matplotlib backend
ENV MPLBACKEND=Agg

# Command to run when the container starts
# CMD ["/bin/bash", "-c", "source ~/.bashrc"]

