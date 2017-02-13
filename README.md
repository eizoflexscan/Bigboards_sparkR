# Spark-Rstudio-Shiny hosted by a BigBoards
--------------------------------------------

## Overview
This repository contains the necessary files for setting up a Spark, Rstudio & Shiny containerized applications up and running on a [Bigboard](www.bigboards.io) cluster.
In addition, a toy example of a Shiny application powered by SparkR is included.

- [Spark](http://spark.apache.org/) is cluster computing framework with implicit data parallelism and fault-tolerance for large-scale data processing. 
It's used here, as well as the distributed machined learning library MLlib, from the R command line through the R packages sparkR and sparkly.   
 
- [RStudio](https://www.rstudio.com/products/rstudio/)RStudio is an integrated development environment (IDE) for R. 
It includes a console, syntax-highlighting editor that supports direct code execution, as well as tools for plotting, history, debugging and workspace management. 
This has proven useful, if you need to run your analysis on a high-end server rather than your laptop and/or if you want all your team members to work on the same R installation.

- [Shiny](https://www.rstudio.com/products/shiny/) is an open source R package that provides an elegant and powerful web framework for building web applications using R. 
It can help you turn your analyses into interactive web applications without necessary requiring HTML, CSS, or JavaScript knowledge.
A toy example of a Shiny application powered by SparkR is included to serve as a demo/template. 


## How to get start (less than 20 minutes)?
To set up the environment and get start super quickly, follow the 2 steps, 

### Install the tint on your HEX
Go on your HEX dashboard (http://master.node.ip:7000) and install the tint "R stack on Spark" by Sven Wauters. It should not take more than 10-15 minutes.

### Launch your favorite web browser

#### Check Spark Web UI
Spark server should be accessible using the port 8080, thus, http://master.node.ip:8080.

#### Start working on RStudio server 
RStudio server should be accessible using the port 8787, thus, http://master.node.ip:8787
- Default username = "rstudio" 
- Default password = "rstudio"

Password can be changed from RStudio shell by typing "passwd" and press the Enter/Return key. 
For details, refer to this [link](http://statistics.byu.edu/content/how-change-rstudio-password). 

But I would recommend to define new users via the master node terminal available on the Bigboards dashboard (i.e. small black boxes).

- Step 1: Find the Rstudio container id
```sh
docker ps
```
-  Step 2: Access the RStudio container
```sh
docker exec -it RStudio-container-id bash
```

-  Step 3a: Add user and password
```sh
adduser new_user_name
```

-  Step 3b: Change password
```sh
passwd user_name
```

-  Step 3c: Remove user
```sh
deluser user_name
```

-  Step 4: Exit
```sh
exit
```

#### Play with Shiny applications 
Shiny applications should be directly accessible with the IP, thus, http://master.node.ip:3838.
You can add as many application as you want using the same structure/template, but a different port for each application should be specified. 
If your Shiny applications require functionality for LDAP authentication and authorization, it can be obtained via a Nginx reverse-proxy image coming soon at Bigboards. 


## How to customize the tint?

### Configuration Folder
These files configure Spark master and workers network.

### Spark_Rstudio Folder
A docker file to build an image with spark, R and RStudio. Although docker strongly advises one application per image, I've decided not to do so. 
To be honest, the main reason was that I was not able to attach the sparkR lib to an R environment while having them in separated containers (i.e. find Spark "absolute" path 
from outside the container environment). But it also simplify things since these application share several libraries.

### Shiny_Application Folder
The files to build a shiny application docker image will typically contain, 
- A dockerfile to build the shiny app
	* with R installation,
	* with R packages installation on which the Shiny app depends on,
- A folder which contains all Shiny app files (ui.R, server.R and others).
- A Rprofile.site to specify the port on which to expose the local application. 



## How to remove the tint? And how to shut down the cluster?

- Before installing a other tint, this one should be first removed. To do so, go to Bigboards dashboard and uninstall the tint. 
If it does not work properly, we can clean the full set up by opening a terminal node and typing
```sh
bb system purge
```

- When you are done, you can shut down the cluster by running the following command in a terminal node
```sh
bb run "shutdown"
```

