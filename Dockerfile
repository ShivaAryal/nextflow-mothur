# FROM nextflow/nextflow
FROM ubuntu:20.04

# RUN chmod 755 /usr/local/bin/nextflow && nextflow info

WORKDIR /my_mothur_flow
COPY . /my_mothur_flow

# https://github.com/mothur/mothur/releases/download/v1.48.0/Mothur.Ubuntu_20.zip

RUN apt-get update && apt-get install -y wget && apt-get install -y unzip

RUN wget https://github.com/mothur/mothur/releases/download/v1.48.0/Mothur.Ubuntu_20.zip && unzip ./Mothur.*

RUN wget https://mothur.s3.us-east-2.amazonaws.com/wiki/silva.bacteria.zip && unzip ./silva.bacteria.zip

RUN cp -a /my_mothur_flow/silva.bacteria/* /my_mothur_flow

# RUN cp /my_mothur_flow/mothur/* /my_mothur_flow
RUN mv mothur mothur-copy

RUN cp -a /my_mothur_flow/mothur-copy/* /my_mothur_flow/