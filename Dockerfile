FROM metacat_server

RUN yum install -y https://download.postgresql.org/pub/repos/yum/reporpms/EL-7-x86_64/pgdg-redhat-repo-latest.noarch.rpm
RUN yum update -y
RUN yum install -y postgresql12-server postgresql12

RUN su - -c "/usr/pgsql-12/bin/initdb" postgres

RUN mkdir -p /config
COPY config.yaml /config/config.yaml
COPY auth_server.conf /config/auth_server.conf

WORKDIR /metacat

COPY entrypoint2.sh /metacat
CMD /metacat/entrypoint2.sh
