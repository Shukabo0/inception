FROM debian:bookworm

RUN apt-get update \
    && apt-get install -y --no-install-recommends nginx openssl \
    && rm -rf /var/lib/apt/lists/*

RUN rm -f /etc/nginx/sites-enabled/default \
    && ln -sf /dev/stdout /var/log/nginx/access.log \
    && ln -sf /dev/stderr /var/log/nginx/error.log \
    && mkdir -p /etc/nginx/ssl

COPY conf/inception.conf /etc/nginx/conf.d/inception.conf
COPY tools/entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chmod +x /usr/local/bin/entrypoint.sh

EXPOSE 443

ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
CMD ["nginx", "-g", "daemon off;"]
