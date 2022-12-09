# handy aliases for working with the docker file
# and doing other stuff

alias build='docker build . -t elon'
alias runrstudio='docker run --rm -p 8787:8787 -p 8080:8080 -v "$(pwd)":/home/rstudio/ -e PASSWORD=password elon'
alias runbash='docker run --rm -p 8787:8787 -p 8080:8080 -v "$(pwd)":/home/rstudio/ -e PASSWORD=password -it elon sudo -H -u rstudio /bin/bash -c "cd ~/; /bin/bash"'
alias runshiny='docker run -p 8080:8080 -v "$(pwd)":/home/rstudio/ -e PASSWORD=pwd -it rcon sudo -H -u rstudio /bin/bash -c "cd ~/; PORT=8080 make shiny"'