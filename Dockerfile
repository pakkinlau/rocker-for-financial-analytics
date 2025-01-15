# Base Rocker image with R and RStudio Server
FROM rocker/rstudio:4.3.1

# Set environment variables
ENV TZ=Etc/UTC \
    R_LIBS_USER=/usr/local/lib/R/site-library \
    CRAN=https://cloud.r-project.org

# Update system and install required system dependencies
RUN apt-get update && apt-get install -y --no-install-recommends \
    libcurl4-openssl-dev \
    libssl-dev \
    libxml2-dev \
    libgit2-dev \
    libjpeg-dev \
    zlib1g-dev \
    libpng-dev \
    libharfbuzz-dev \
    libfribidi-dev \
    python3 \
    python3-pip \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

# Install Jupyter and its dependencies
RUN pip3 install --no-cache-dir \
    jupyter \
    jupyterlab

# Install IRkernel for Jupyter Notebook
RUN R -e "install.packages('IRkernel', repos='${CRAN}')"
RUN R -e "IRkernel::installspec(user = FALSE)"

# Install essential R packages for financial analytics
RUN R -e "install.packages(c( \
    'tidyverse', 'data.table', 'lubridate', \
    'ggplot2', 'plotly', 'shiny', 'leaflet', \
    'quantmod', 'TTR', 'PerformanceAnalytics', \
    'PortfolioAnalytics', 'xts', 'zoo', \
    'forecast', 'prophet', 'rugarch', \
    'httr', 'jsonlite', 'DBI', 'RSQLite', \
    'highcharter', 'knitr', \
    'stringr', 'readxl', 'writexl', \
    'timeSeries', 'TSstudio', 'corrplot', \
    'ggpubr', 'factoextra', 'gridExtra', \
    'reshape2', 'blotter', 'quantstrat', \
    'alphavantager','languageserver', 'httpgd','rmarkdown' \
    ), repos='${CRAN}')"

# Install renv for dependency management
RUN R -e "install.packages('renv', repos='${CRAN}')"

# Expose ports for RStudio Server (8787) and Jupyter Notebook (8888)
EXPOSE 8787 8888

# Set working directory
WORKDIR /home/rstudio

# Create a persistent data directory
RUN mkdir -p /home/rstudio/data && chmod -R 777 /home/rstudio/data

# Default command to start RStudio Server
CMD ["/init"]
