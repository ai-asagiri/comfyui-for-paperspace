FROM nvidia/cuda:12.4.0-devel-ubuntu22.04
# FROM nvidia/cuda:12.4.0-runtime-ubuntu22.04

ENV DEBIAN_FRONTEND=noninteractive
ENV TZ=UTC
                                  
RUN apt-get update && apt-get install -y \
  build-essential \
  cmake \
  git \
  libopenblas-dev \
  liblapack-dev \
  libeigen3-dev \
  python3-pip \
  && rm -rf /var/lib/apt/lists/* \
  && apt-get clean \
  && pip3 install --upgrade pip \
  && pip3 install --no-cache-dir \
  torch torchvision torchaudio --extra-index-url https://download.pytorch.org/whl/cu124 \
  numpy \
  jupyter \
  jupyterlab \
  "notebook<7.0.0" \
  jupyter_contrib_nbextensions \
  jupyter_nbextensions_configurator \
  ipywidgets \
  && rm -rf /root/.cache/pip \
  && jupyter contrib nbextension install --system \
  && jupyter nbextension enable --system widgetsnbextension


COPY entrypoint.sh /
RUN chmod +x /entrypoint.sh

WORKDIR /notebooks_tmp
RUN git clone https://github.com/comfyanonymous/ComfyUI.git
WORKDIR /notebooks_tmp/ComfyUI
RUN pip3 install --no-cache-dir -r requirements.txt

WORKDIR /notebooks_tmp/ComfyUI/custom_nodes
RUN git clone https://github.com/ltdrdata/ComfyUI-Manager.git \
  && git clone https://github.com/11cafe/comfyui-workspace-manager.git \
  && cd /notebooks_tmp/ComfyUI/custom_nodes/ComfyUI-Manager \
  && pip3 install -r requirements.txt \
  && cd /notebooks_tmp/ComfyUI/custom_nodes/comfyui-workspace-manager \
  && pip3 install -r requirements.txt

COPY run-comfyui.ipynb /notebooks_tmp/
RUN chmod 644 /notebooks_tmp/run-comfyui.ipynb

WORKDIR /notebooks_tmp

ENTRYPOINT ["/entrypoint.sh"]
CMD ["jupyter", "lab", "--ip=0.0.0.0", "--port=8888", "--allow-root", "--NotebookApp.token=''", "--NotebookApp.password=''", "--no-browser", "--ServerApp.allow_origin=*", "--ServerApp.allow_remote_access=True", "--notebook-dir=/notebooks"]
