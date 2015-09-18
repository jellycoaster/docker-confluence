FROM ubuntu:14.04

MAINTAINER mintplo <mintplo21@gmail.com>

# Set Envrionmental Variable
ENV CONFLUENCE_LATEST_VER 5.8.10


# Install basic package
RUN apt-get update && apt-get install -y \
	python-software-properties \
	software-properties-common \
	debconf-utils

# Install JRE 1.8 with silent mode
# install error issue with JRE 1.8 installer license agreement
# 
# http://askubuntu.com/questions/190582/installing-java-automatically-with-silent-option
RUN add-apt-repository -y ppa:webupd8team/java && apt-get update
RUN echo "oracle-java8-installer shared/accepted-oracle-license-v1-1 select true" | sudo debconf-set-selections
RUN apt-get install -y \
	oracle-java8-installer \
	oracle-java8-set-default


# Install Confluence with silent mode
# https://confluence.atlassian.com/display/DOC/Installing+Confluence+on+Linux
ADD response.varfile /home/
ADD https://www.atlassian.com/software/confluence/downloads/binary/atlassian-confluence-$CONFLUENCE_LATEST_VER-x64.bin /home/confluence.bin
RUN chmod 777 /home/confluence.bin
RUN /home/confluence.bin -q -varfile /home/response.varfile
RUN rm -rf /home/confluence.bin


VOLUME ["/var/atlassian", "/opt/atlassian/confluence"]

ENTRYPOINT ["/opt/atlassian/confluence/bin/start-confluence.sh", "-fg"]


EXPOSE 8000
EXPOSE 8090
