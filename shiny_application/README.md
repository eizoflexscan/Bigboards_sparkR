
# Shiny Application Template

This repository provides a template to deploy your own Shiny apps on [ShinyProxy](http://www.shinyproxy.io).

Shiny is a web application framework for R to turn your analyses into interactive web applications. Since the open source edition of Shiny Server does not offer security and authentification (only the Pro version does), ShinyProxy is used on top of the shiny library. This free open-source library, developed by Open Analytics allows to deploy Shiny apps in an enterprise context. It has built-in functionality for LDAP authentication and authorization, makes securing Shiny traffic (over TLS) a breeze and has no limits on concurrent usage of a Shiny app. All information can be found [here](http://www.shinyproxy.io). You might also want to contact the package owner [Open Analytics](https://www.openanalytics.eu/). From waht I've heard, they offer great support and services.

Full explanation on the contents of this repository is offered at http://www.shinyproxy.io/deploying-apps/


## Pre-request

* ShinyProxy is installed. If not, refer to the folder names 'shinyproxy' in the root repository.
* Docker is installed. If not, go to Docker web site. 


## Add your Shiny App
Add your shiny application in the folder names 'MyApp'. 

## Build the Docker Image

### Step 1: Load pre-existing image
Tells Docker which image your image is based on with the "FROM" keyword. In our case, we'll use the Bigboards base image bigboards/java-8-x86_64 as the foundation to build our app.

```
FROM bigboards/java-8-x86_64
```


### Step 2 : Install dependencies

Install system libraries of general use external to R and Rstudio,

```
RUN apt-get update && apt-get install -y \
    sudo \
    pandoc \
    pandoc-citeproc \
    libcurl4-gnutls-dev \
    libcairo2-dev \
    libxt-dev \
    libssl-dev \
    libssh2-1-dev \
    libssl1.0.0 \
    libmpfr-dev
 ```


### Step 3: Download and install R Packages
Install as many R packages as you want by completing the list. But if you want to install Shiny Server later on, you must add shiny to the list before installing Shiny Server.

```
RUN R -e "install.packages(c('shiny', 'rmarkdown'), repos='https://cloud.r-project.org/')"
```

### Step4: Copy the app to the image
Create a folder name 'MyApp' at the root of the image and copy MyApp folder including the shiny application files onto the image in folder '/root/MyApp'.

```
RUN mkdir /root/MyApp
COPY MyApp /root/MyApp
```

### Step5: Copy the app to the image
The line that copies the Rprofile.site onto the image will make sure your Shiny app will run on the port expected by ShinyProxy and also ensures that one will be able to connect to the Shiny app from the outside world/.

```
COPY Rprofile.site /usr/lib/R/etc/
```

### Step5: Expose the Shiny proxy port
Associate the 3838 specified port to enable networking between the running process inside the container and the outside world (otherwise it will not be possible to connect to the Shiny application).
```
EXPOSE 3838
```

### Step 6: Start Shiny app
The command CMD, similarly to RUN, can be used for executing a specific command. However, unlike RUN it is not executed during build, but when a container is instantiated using the image being built. Therefore, it should be considered as an initial, default command that gets executed (i.e. run) with the creation of containers based on the image to start the Shiny app.
```
CMD ["R", "-e shiny::runApp('/root/MyApp')"]
```



## Credit
All credit goes to Open Analytics! This repository is nothing more than a summary of their [documentation](http://www.shinyproxy.io/deploying-apps/).

