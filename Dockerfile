FROM nginx:1.24-alpine

ARG VERSION=0.0.0
ENV VERSION=${VERSION}

# CGit
ARG CGIT_VERSION=1.2.3-r2
ENV CGIT_VERSION=${CGIT_VERSION}

# CGit default options
ENV CGIT_TITLE="CGit"
ENV CGIT_DESC="The hyperfast web frontend for Git repositories"
ENV CGIT_VROOT="/"
ENV CGIT_SECTION_FROM_STARTPATH=0
ENV CGIT_MAX_REPO_COUNT=50

LABEL version="${VERSION}" \
    description="The hyperfast web frontend for Git repositories on top of Alpine and Nginx." \
    maintainer="Jose Quintana <joseluisq.net>"

RUN set -eux \
    && apk add --no-cache \
        ca-certificates \
        cgit=${CGIT_VERSION} \
        fcgiwrap \
        git \
        lua5.3-libs \
        py3-markdown \
        py3-pygments \
        python3 \
        spawn-fcgi \
        tzdata \
        xz \
        zlib \
    && rm -rf /var/cache/apk/* \
    && rm -rf /tmp/* \
    && true

COPY cgit/cgit.conf /tmp/cgitrc.tmpl
COPY docker-entrypoint.sh /
COPY nginx/nginx.conf /etc/nginx/nginx.conf
COPY nginx/conf.d/default.conf /etc/nginx/conf.d/default.conf

RUN set -eux \
    && echo "Creating application directories..." \
    && mkdir -p /var/cache/cgit \
    && mkdir -p /srv/git \
    && true

RUN set -eux \
    && echo "Testing Nginx server configuration files..." \
    && nginx -c /etc/nginx/nginx.conf -t \
    && true

ENTRYPOINT [ "/docker-entrypoint.sh" ]

EXPOSE 80

STOPSIGNAL SIGQUIT

CMD [ "nginx", "-g", "daemon off;" ]


# Metadata
LABEL org.opencontainers.image.vendor="Jose Quintana" \
    org.opencontainers.image.url="https://github.com/joseluisq/alpine-cgit" \
    org.opencontainers.image.title="cgit" \
    org.opencontainers.image.description="The hyperfast web frontend for Git repositories on top of Alpine and Nginx." \
    org.opencontainers.image.version="${VERSION}" \
    org.opencontainers.image.documentation="https://github.com/joseluisq/alpine-cgit"
