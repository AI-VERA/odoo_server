#------------------------
# Dockerfile:
# odoo_server
#------------------------

FROM ubuntu:24.04

ARG DEBIAN_FRONTEND=noninteractive

RUN apt update
# use apt cache
#RUN echo 'Acquire::http::Proxy "http://acn.home.lan:3142";' \
#    > /etc/apt/apt.conf.d/01proxy
# detect-http-proxy needs netcat
RUN apt install -y netcat-openbsd
COPY apt/detect-http-proxy /etc/apt/detect-http-proxy
RUN chmod 555 /etc/apt/detect-http-proxy
COPY apt/01proxy /etc/apt/apt.conf.d/01proxy

RUN apt update && apt upgrade -y

# install dependencies
RUN apt install -y \
    wget gpg curl nano \
    postgresql

# add odoo repository
RUN wget -q -O - https://nightly.odoo.com/odoo.key | \
    gpg --dearmor -o /usr/share/keyrings/odoo-archive-keyring.gpg
# do not use https url in case we use apt-cacher-ng
RUN echo 'deb [signed-by=/usr/share/keyrings/odoo-archive-keyring.gpg] http://nightly.odoo.com/18.0/nightly/deb/ ./' | \
    tee /etc/apt/sources.list.d/odoo.list
RUN apt update

# install dependencies
RUN apt install -y \
    odoo

#RUN apt install -y \
#    python3-pip \
#    python3-xlwt python3-num2words python3-lxml python3-lxml-html-clean

RUN apt install -y \
   sudo postgresql-client

COPY init_db.sh /
RUN chmod 555 /init_db.sh

# get ip
RUN echo "awk '/32 host/ { print f } {f=\$2}' /proc/net/fib_trie" \
    > /get_ip.sh && chmod 555 /get_ip.sh

# health check
COPY health-check.sh /
RUN chmod 555 /health-check.sh
HEALTHCHECK --interval=30s --timeout=3s \
  CMD /health-check.sh || exit 1

COPY init.sh /
RUN chmod 555 /init.sh

ENTRYPOINT ["/init.sh"]
