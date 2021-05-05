FROM ubuntu:18.04
RUN apt-get update
RUN apt-get install apache2 -y
WORKDIR /var/www/html
RUN ["/bin/bash", "-c", "echo hello potato > index.html"]
EXPOSE 80
CMD apachectl -DFOREGROUND