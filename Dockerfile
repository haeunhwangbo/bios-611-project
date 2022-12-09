FROM rocker/verse
RUN apt-get update && apt-get install -y openssh-server python3-pip python3
RUN pip3 install numpy scipy pandas matplotlib seaborn scikit-learn jupyterlab
RUN R -e "install.packages(c(\"shiny\"))";
RUN R -e "install.packages(\"reticulate\")";
RUN R -e "install.packages(\"tidytext\")";
RUN R -e "install.packages(\"textdata\")";
RUN R -e "install.packages(\"wordcloud\")";
RUN R -e "install.packages(\"gbm\")";
RUN R -e "install.packages(\"GGally\")";
RUN R -e "install.packages(\"ggcorrplot\")";
RUN R -e "install.packages(\"ggpubr\")";
