FROM python:3.8-slim-buster

RUN mkdir /app

COPY ./*.txt ./*.py ./*.sh ./*.onnx /app/

RUN cd /app \
    && python3 -m pip install --upgrade pip \
    && pip3 install --no-cache-dir -r requirements.txt \
    && apt-get --allow-releaseinfo-change update \
    && apt-get install -y libgl1-mesa-glx libglib2.0-0 \
    && apt-get clean -y \
    && apt-get autoclean -y \
    && apt-get autoremove -y \
    && rm -rf /tmp/* && rm -rf /root/.cache/* \
    && rm -rf /var/lib/{apt,dpkg,cache,log}/

WORKDIR /app

CMD ["python3", "ocr_server.py", "--port", "9898", "--ocr", "--det"]
