FROM isle-crayfish-base:latest
# Apache https://github.com/docker-library/php/blob/04c0ee7a0277e0ebc3fcdc46620cf6c1f6273100/7.4/buster/apache/Dockerfile

## Tesseract and pdftotext
# @see: https://packages.debian.org/buster/tesseract-ocr
# @see: https://packages.debian.org/buster/poppler-utils

RUN TESSERACT_PACKS="tesseract-ocr \
    tesseract-ocr-eng \
    tesseract-ocr-fra \
    tesseract-ocr-spa \
    tesseract-ocr-ita \
    tesseract-ocr-por \
    tesseract-ocr-hin \
    tesseract-ocr-deu \
    tesseract-ocr-jpn \
    tesseract-ocr-rus \
    poppler-utils" && \
    apt-get update && \
    apt-get install --no-install-recommends -y $TESSERACT_PACKS && \
    apt-get purge -y --auto-remove -o APT::AutoRemove::RecommendsImportant=false && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

COPY rootfs /

# Composer & Hypercube
# @see: Composer https://github.com/composer/getcomposer.org/commits/master (replace hash below with most recent hash)
# @see: Hypercube https://github.com/Islandora/Crayfish

ENV PATH=$PATH:$HOME/.composer/vendor/bin \
    COMPOSER_ALLOW_SUPERUSER=1 \
    COMPOSER_HASH=${COMPOSER_HASH:-b9cc694e39b669376d7a033fb348324b945bce05} \
    HYPERCUBE_BRANCH=dev

RUN curl https://raw.githubusercontent.com/composer/getcomposer.org/$COMPOSER_HASH/web/installer --output composer-setup.php --silent && \
    php composer-setup.php --filename=composer --install-dir=/usr/local/bin && \
    rm composer-setup.php && \
    mkdir -p /opt/crayfish && \
    git clone -b $HYPERCUBE_BRANCH https://github.com/Islandora/Crayfish.git /opt/crayfish && \
    composer install -d /opt/crayfish/Hypercube && \
    chown -Rv www-data:www-data /opt/crayfish && \
    mkdir /var/log/islandora && \
    chown www-data:www-data /var/log/islandora && \
    a2dissite 000-default && \
    #echo "ServerName localhost" | tee /etc/apache2/conf-available/servername.conf && \
    #a2enconf servername && \
    a2enmod rewrite deflate headers expires proxy proxy_http proxy_html proxy_connect remoteip xml2enc cache_disk

ARG BUILD_DATE
ARG VCS_REF
ARG VERSION
LABEL org.label-schema.build-date=$BUILD_DATE \
      org.label-schema.name="ISLE 8 Hypercube Image" \
      org.label-schema.description="ISLE 8 Hypercube" \
      org.label-schema.url="https://islandora.ca" \
      org.label-schema.vcs-ref=$VCS_REF \
      org.label-schema.vcs-url="https://github.com/Islandora-Devops/isle-Hypercube" \
      org.label-schema.vendor="Islandora Devops" \
      org.label-schema.version=$VERSION \
      org.label-schema.schema-version="1.0"

WORKDIR /opt/crayfish/Hypercube/
