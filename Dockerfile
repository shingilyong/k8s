FROM CentOS:latest

RUN yum -u install httpd
RUN sudo systemctl start httpd
RUN sudo systemctl enable httpd
ADD web.tml /var/www/html
EXPOSE 80