FROM alpine:latest
ARG FREEDNS_User
ARG FREEDNS_Password
ARG EMAIL
ARG DOMAIN
VOLUME [ "/cert" ]

RUN apk --no-cache add -f \
  openssl \
  openssh-client \
  coreutils \
  bind-tools \
  curl \
  sed \
  socat \
  tzdata \
  oath-toolkit-oathtool \
  tar \
  libidn \
  jq \
  cronie
RUN mkdir -p /cert

RUN echo '#!/bin/sh' > /issuecert.sh \
  && echo "/root/.acme.sh/acme.sh --server letsencrypttest --register-account -m \$EMAIL" >> /issuecert.sh \
  && echo "/root/.acme.sh/acme.sh --issue --server letsencrypttest --dns dns_freedns -d \$DOMAIN --cert-home /cert --cert-file /cert/le.cer --key-file /cert/le.key" >> /issuecert.sh
RUN chmod +x /issuecert.sh
#ENTRYPOINT ["/entrypoint.sh"]

RUN curl https://get.acme.sh | sh && curl https://raw.githubusercontent.com/acmesh-official/acme.sh/refs/heads/master/dnsapi/dns_freedns.sh --output /root/.acme.sh/dns_freedns.sh
