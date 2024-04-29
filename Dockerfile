# Use an official Python runtime as a parent image
FROM balenalib/raspberrypi4-64-python:3.11-buster-build

# set environment variable for cert and key path
ENV SSL_CERT_PATH=tests/ssl_cert.pem
ENV SSL_KEY_PATH=tests/ssl_key.pem
ENV SERVER_PORT=4433
ENV SERVER_HOST=0.0.0.0

# Install necessary packages and dependencies
RUN apt-get update \
    && apt-get install -y gcc git libssl-dev python3-dev \
    && apt-get clean

# Install HTTP/3 dependencies

COPY ${SSL_CERT_PATH} /opt/app/tests/ssl_cert.pem
COPY ${SSL_KEY_PATH} /opt/app/tests/ssl_key.pem
COPY tests/pycacert.pem /opt/app/tests/pycacert.pem

COPY requirements.txt /opt/app/requirements.txt
RUN pip install -r /opt/app/requirements.txt

COPY .env.example /opt/app/.env.example
COPY . /opt/app/
COPY http3_server.py /opt/app/http3_server.py
COPY AnansiServer.py /opt/app/AnansiServer.py
ADD htdocs /opt/app/htdocs
ADD templates /opt/app/templates

WORKDIR /opt/app

# Expose necessary ports
EXPOSE ${SERVER_PORT}/tcp
EXPOSE ${SERVER_PORT}/udp

CMD sh local-run.sh
