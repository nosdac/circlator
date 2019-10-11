#   ____ _          _       _             
#  / ___(_)_ __ ___| | __ _| |_ ___  _ __ 
# | |   | | '__/ __| |/ _` | __/ _ \| '__|
# | |___| | | | (__| | (_| | || (_) | |   
#  \____|_|_|  \___|_|\__,_|\__\___/|_|   
#                                        
# Circlator
# Created by Björn Viklund
# Contact: bjorn.viklund@uppmax.uu.se
# https://github.com/sanger-pathogens/circlator
FROM debian:testing-20190910

# Set workdir and variables
WORKDIR /opt 
ENV LC_ALL=C.UTF-8
ENV BUILD_DIR=/opt/circlator

# Install the dependancies
RUN apt-get update -qq && apt-get install -y	\ 
                                                git=1:2.23.0-1 \
                                                libbz2-dev=1.0.8-2 \
                                                libcurl4-openssl-dev=7.66.0-1 \
                                                libcurl4=7.66.0-1 \
                                                liblzma-dev=5.2.4-1+b1 \
                                                libncurses5-dev=6.1+20190803-1 \
                                                python3-pip=18.1-5 \
                                                python=2.7.16-1 \
                                                unzip=6.0-25 \
                                                wget=1.20.3-1+b1 \
                                                zlib1g-dev=1:1.2.11.dfsg-1+b1 

                                                #libssl-dev=1.1.1d-1 \
# Clone and install even more dependencies
RUN git clone https://github.com/sanger-pathogens/circlator.git
RUN cd circlator && git reset --hard '3103d78299f8c4' && ./install_dependencies.sh

# Set PATH
ENV PATH="${BUILD_DIR}/build/bwa-0.7.12:${BUILD_DIR}/build/canu-1.4/Linux-amd64/bin/:${BUILD_DIR}/build/prodigal-2.6.2:${BUILD_DIR}/build/samtools-1.3:${BUILD_DIR}/build/MUMmer3.23:${BUILD_DIR}/build/SPAdes-3.7.1-Linux/bin:$PATH"

# Run the final installation
RUN cd ${BUILD_DIR} && python3 setup.py install
ENV PYTHONPATH=/usr/local/lib/python3.7/dist-packages/pysam-0.15.3-py3.7-linux-x86_64.egg:/usr/local/lib/python3.7/dist-packages/circlator-1.5.5-py3.7.egg:/usr/local/lib/python3.7/dist-packages/pymummer-0.11.0-py3.7.egg:/usr/local/lib/python3.7/dist-packages/pyfastaq-3.17.0-py3.7.egg:/usr/local/lib/python3.7/dist-packages/openpyxl-3.0.0-py3.7.egg:/usr/local/lib/python3.7/dist-packages/jdcal-1.4.1-py3.7.egg:/usr/local/lib/python3.7/dist-packages/et_xmlfile-1.0.1-py3.7.egg:

# Remove unnecessary softwares
RUN apt autoremove -y git unzip wget

# Final sanity check
RUN   circlator progcheck

RUN echo "alias l='ls -l --color=always --group-directories-first'" >> ~/.bashrc

ENTRYPOINT ["circlator"]
