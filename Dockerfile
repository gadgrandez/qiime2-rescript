FROM continuumio/miniconda3

ENV QIIME2_RELEASE=2021.4

ENV PATH /opt/conda/envs/qiime2-${QIIME2_RELEASE}/bin:$PATH
ENV LC_ALL C.UTF-8
ENV LANG C.UTF-8
ENV MPLBACKEND agg
ENV HOME /home/qiime2
ENV XDG_CONFIG_HOME /home/qiime2

RUN mkdir /home/qiime2
WORKDIR /home/qiime2

RUN conda update -q -y conda
RUN conda install -q -y wget
RUN apt-get install -y procps
RUN wget https://data.qiime2.org/distro/core/qiime2-${QIIME2_RELEASE}-py38-linux-conda.yml
RUN conda env create -n qiime2-${QIIME2_RELEASE} --file qiime2-${QIIME2_RELEASE}-py38-linux-conda.yml
RUN rm qiime2-${QIIME2_RELEASE}-py38-linux-conda.yml
RUN /bin/bash -c "source activate qiime2-${QIIME2_RELEASE}"
RUN qiime dev refresh-cache
RUN echo "source activate qiime2-${QIIME2_RELEASE}" >> $HOME/.bashrc
RUN echo "source tab-qiime" >> $HOME/.bashrc

# Installing rescript
RUN conda install -c conda-forge -c bioconda -c qiime2 -c defaults xmltodict
RUN pip install xmltodict
RUN pip install git+https://github.com/bokulich-lab/RESCRIPt.git

# TODO: update this to point at the new homedir defined above. Keeping this
# for now because this will require an update to the user docs.
VOLUME ["/workspace"]
WORKDIR /workspace
