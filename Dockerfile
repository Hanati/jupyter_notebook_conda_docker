FROM ubuntu:16.04

## https://hub.docker.com/r/continuumio/miniconda3/~/dockerfile/

ENV LANG=C.UTF-8 LC_ALL=C.UTF-8

RUN apt-get update --fix-missing && \
    apt-get install -y wget bzip2 ca-certificates curl git && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

RUN echo 'export PATH=/opt/conda/bin:$PATH' > /etc/profile.d/conda.sh && \
    wget --quiet https://repo.continuum.io/miniconda/Miniconda3-4.4.10-Linux-x86_64.sh -O ~/miniconda.sh && \
    /bin/bash ~/miniconda.sh -b -p /opt/conda && \
    rm ~/miniconda.sh && \
    /opt/conda/bin/conda clean -tipsy

ENV TINI_VERSION v0.16.1
ADD https://github.com/krallin/tini/releases/download/${TINI_VERSION}/tini /usr/bin/tini
RUN chmod +x /usr/bin/tini

ENV PATH /opt/conda/bin:$PATH

RUN conda install jupyter -y --quiet

## passwd conda-book
RUN jupyter notebook --generate-config
RUN echo "c.NotebookApp.password='sha1:***'">>/root/.jupyter/jupyter_notebook_config.py
 
WORKDIR /home
## ENTRYPOINT [ "/usr/bin/tini", "--" ]
EXPOSE 8888
CMD [ "jupyter","notebook","--ip='*'","--no-browser","--allow-root"]
