# This container will install Circlator from master
#
FROM debian:testing-20190910

ENV BUILD_DIR=/opt/circlator

# Install the dependancies
RUN apt-get update -qq && apt-get install -y	\ 
                                                git=1:2.23.0-1 \
                                                libbz2-dev=1.0.8-2 \
                                                liblzma-dev=5.2.4-1+b1 \
                                                libncurses5-dev=6.1+20190803-1 \
                                                python3-pip=18.1-5 \
                                                python=2.7.16-1 \
                                                unzip=6.0-25 \
                                                wget=1.20.3-1+b1 \
                                                zlib1g-dev=1:1.2.11.dfsg-1+b1 

RUN   mkdir -p ${BUILD_DIR}

ENV BUILD_DIR=/opt/circlator
WORKDIR /opt 
RUN git clone https://github.com/sanger-pathogens/circlator.git
RUN cd circlator && git reset --hard '3103d78299f8c4' && ./install_dependencies.sh
RUN echo "alias l='ls -l --color=always --group-directories-first'" >> ~/.bashrc

ENV PATH="${BUILD_DIR}/build/bwa-0.7.12:${BUILD_DIR}/build/canu-1.4/Linux-amd64/bin/:${BUILD_DIR}/build/prodigal-2.6.2:${BUILD_DIR}/build/samtools-1.3:${BUILD_DIR}/build/MUMmer3.23:${BUILD_DIR}/build/SPAdes-3.7.1-Linux/bin:$PATH"

RUN apt update -qq && apt install -y libcurl4=7.66.0-1 libcurl4-openssl-dev=7.66.0-1 

RUN   cd ${BUILD_DIR} && python3 setup.py install

RUN   circlator progcheck

CMD   echo "Usage:  docker run -v \`pwd\`:/var/data -it <IMAGE_NAME> bash" && \
      echo "" && \
      echo "This will place you in a shell with your current working directory accessible as /var/data." && \
      echo "You can then run commands like:" && \
      echo "   circlator all /var/data/assembly.fasta /var/data/reads /var/data/<output_subdirectory>" && \
      echo "For help, please go to https://github.com/sanger-pathogens/circlator/wiki, or type" && \
      echo "   circlator --help"
CMD circlator

ENTRYPOINT ["circlator"]
