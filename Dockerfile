FROM jupyter/r-notebook

RUN python3 -m pip install jupyter-rsession-proxy
RUN cd /tmp/ && \
    git clone --depth 1 https://github.com/jupyterhub/jupyter-server-proxy && \
    cd jupyter-server-proxy/jupyterlab-server-proxy && \
    npm install && npm run build && jupyter labextension link . && \
    npm run build && jupyter lab build


# install rstudio-server

USER root
RUN echo '\ndeb http://security.ubuntu.com/ubuntu xenial-security main' >> sudo nano /etc/apt/sources.list && \
    cat /etc/apt/sources.list && \
    apt-get update && \
    sudo apt install libssl1.0.0 && \
    curl --silent -L --fail https://download2.rstudio.org/rstudio-server-1.1.463-amd64.deb > /tmp/rstudio.deb && \
    echo 'e8f3d9c3c5ca1df9827c6843b7ac5ab4 /tmp/rstudio.deb' | md5sum -c - && \
    apt-get install -y /tmp/rstudio.deb && \
    rm /tmp/rstudio.deb && \
    apt-get clean && rm -rf /var/lib/apt/lists/*
ENV PATH=$PATH:/usr/lib/rstudio-server/bin
USER $NB_USER