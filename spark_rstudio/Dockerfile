#------------------------------------------------------------------------------------------------
# All credits goes to 
#'(1) Angel Sevilla Camins (https://github.com/angelsevillacamins/spark-rstudio-shiny), 
#'(2) KoenR3 (https://github.com/bigboards/docker-rstudio-server) 
#'(3) Bigboards (https://github.com/bigboards/bb-stack-spark) and 
#'(4) Open Analytics (https://github.com/openanalytics/shinyproxy-template). 
# This dockerfile and its configuration files are nothing more than a copy/paste of their work.
#------------------------------------------------------------------------------------------------

# Load pre-existing image
FROM ubuntu:14.04

MAINTAINER svenwauters@gmail.com

# Set environment variables
ENV SPARK_VERSION 2.1.0
ENV RSTUDIO_VERSION 1.0.136
ENV PASSWORD rstudio

# Install Java8 and RStudio server dependencies (from relateiq/oracle-java8)
RUN echo "deb http://ppa.launchpad.net/webupd8team/java/ubuntu trusty main" | tee -a /etc/apt/sources.list
RUN echo "deb-src http://ppa.launchpad.net/webupd8team/java/ubuntu trusty main" | tee -a /etc/apt/sources.list
RUN echo oracle-java8-installer shared/accepted-oracle-license-v1-1 select true | /usr/bin/debconf-set-selections
RUN apt-key adv --keyserver keyserver.ubuntu.com --recv-keys EEA14886
RUN apt-get -y update \
&& apt-get install -y --no-install-recommends \
    ca-certificates \
    gdebi-core \
    git \
    libapparmor1 \
    libedit2 \
    libcairo2-dev \
    libcurl4-openssl-dev \
    libssl1.0.0 \
    libssl-dev \
    libxml2-dev \
    libxt-dev \
    lsb-release \
    nano \
    psmisc \
    python-setuptools \
    openssh-client \
    oracle-java8-installer \
    software-properties-common \
    sudo \
    supervisor \
    pandoc \
    pandoc-citeproc \
    wget \
&& rm -rf /var/lib/apt/lists/


# Add Java binaries to PATH (Java home directory must be set, otherwise, Spark doesn't work properly)
ENV JAVA_HOME /usr/lib/jvm/java-8-oracle/jre
ENV PATH=$JAVA_HOME/bin:$PATH


# Configure default locale for R (see https://github.com/rocker-org/rocker/issues/19)
RUN echo "en_US.UTF-8 UTF-8" >> /etc/locale.gen \
  && locale-gen en_US.utf8 \
  && /usr/sbin/update-locale LANG=en_US.UTF-8

ENV LC_ALL en_US.UTF-8
ENV LANG en_US.UTF-8


# Install the latest R Base 
RUN codename=$(lsb_release -c -s) && \
	echo "deb http://freestatistics.org/cran/bin/linux/ubuntu $codename/" | tee -a /etc/apt/sources.list > /dev/null && \
	apt-key adv --keyserver keyserver.ubuntu.com --recv-keys E084DAB9 && \
	apt-get update && apt-get install -y r-base r-base-dev

# Install some R libraries/packages from CRAN
RUN R -e 'install.packages(c("tidyr","devtools","dplyr", "ggplot2", "sparklyr"), repos="http://cran.freestatistics.org/")'  && \
	R -e 'update.packages(ask=FALSE,repos="http://cran.freestatistics.org/")'

# Install some R libraries/packages from Github
# RUN	R -e 'devtools::install_github("rstudio/sparklyr")'
	

	
# Install RStudio
RUN wget -O /tmp/rstudio.deb http://download2.rstudio.org/rstudio-server-${RSTUDIO_VERSION}-amd64.deb && \
    gdebi -n /tmp/rstudio.deb && \
    rm /tmp/rstudio.deb    	

# Add R-base, RStudio binaries to PATH
ENV PATH /usr/lib/rstudio-server/bin/:$PATH
ENV PATH /usr/local/bin/:$PATH

# A default user system configuration
## -> rstudio user is created 
## -> /home/rstudio folders owner is changed since they are owned by root after RStudio installation. 
RUN useradd -m -d /home/rstudio rstudio \
  && echo "rstudio:${PASSWORD}" | chpasswd \
  && chown -R rstudio /home/rstudio

    
# Install Spark (from https://www.anchormen.nl/spark-docker/)
RUN wget http://apache.mirror.triple-it.nl/spark/spark-${SPARK_VERSION}/spark-${SPARK_VERSION}-bin-hadoop2.6.tgz \
&&  tar -xzf spark-${SPARK_VERSION}-bin-hadoop2.6.tgz \
&&  mv spark-${SPARK_VERSION}-bin-hadoop2.6 /opt/spark \
&&  rm spark-${SPARK_VERSION}-bin-hadoop2.6.tgz

ENV SPARK_HOME /opt/spark
ENV PATH $PATH:$SPARK_HOME/bin

# Set SPARK_HOME and the Spark installation directory in R environment
RUN echo "SPARK_HOME=$SPARK_HOME" >> /etc/R/Renviron.site
RUN echo "spark.install.dir=/opt/spark" >> /etc/R/Renviron.site


# Expose port 8080 for spark master UI and 8787 for Rstudio
#        master    worker   Rstudio
#     +---------+---------+----+
EXPOSE 7077 8080 7078 8081 8787
