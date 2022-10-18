FROM rocker/verse
RUN apt update && apt-get install -y openssh-server python3-pip
RUN pip3 install numpy scipy pandas matplotlib seaborn scikit-learn
RUN R -e "install.packages(c(\"shiny\"))"
RUN R -e "install.packages(\"reticulate\")";
RUN R -e "install.packages(\"gbm\")";
RUN R -e "install.packages(\"GGally\")";
