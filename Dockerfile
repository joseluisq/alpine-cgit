FROM nginx:1.19-alpine

# CGit
ARG CGIT_VERSION=1.2.3-r0
ENV CGIT_VERSION=${CGIT_VERSION}
ENV CGIT_TITLE="cgit"
ENV CGIT_DESC="A fast web interface for Git"
ENV CGIT_VROOT="/"
ENV CGIT_SECTION_FROM_STARTPATH=0
ENV CGIT_MAX_REPO_COUNT=50

LABEL version="${CGIT_VERSION}" \
    description="A fast web interface for Git." \
    maintainer="Jose Quintana <joseluisq.net>"

RUN set -eux \
    && apk add --no-cache \
        ca-certificates \
        cgit=${CGIT_VERSION} \
        fcgiwrap \
        git \
        highlight \
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

COPY conf/cgit.conf /tmp/cgitrc.tmpl
COPY conf/default.conf /etc/nginx/conf.d/default.conf

VOLUME [ "/srv/git", "/var/cache/cgit" ]

CMD chown nginx:nginx /var/cache/cgit \
    && chmod u+g /var/cache/cgit \
    && envsubst < /tmp/cgitrc.tmpl > /etc/cgitrc \
    && spawn-fcgi \
        -u nginx -g nginx \
        -s /var/run/fcgiwrap.sock \
        -n -- /usr/bin/fcgiwrap \
    & nginx -g "daemon off;"

# Metadata
LABEL org.opencontainers.image.vendor="Jose Quintana" \
    org.opencontainers.image.url="https://github.com/joseluisq/alpine-cgit" \
    org.opencontainers.image.title="cgit" \
    org.opencontainers.image.description="A fast web interface for git." \
    org.opencontainers.image.version="${SERVER_VERSION}" \
    org.opencontainers.image.documentation="https://github.com/joseluisq/alpine-cgit"
