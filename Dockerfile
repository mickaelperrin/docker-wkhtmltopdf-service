FROM golang:1.4

MAINTAINER Potiguar Faga <potz@potz.me>
MAINTAINER Mickaël PERRIN <contact@mickaelperrin.fr>

ENV DOWNLOAD_URL "https://github.com/wkhtmltopdf/wkhtmltopdf/releases/download/0.12.5/wkhtmltox_0.12.5-1.jessie_amd64.deb"

# Create system user first so the User ID gets assigned
# consistently, regardless of dependencies added later
RUN useradd -rM appuser && \
    apt-get update && \
    apt-get install -y --no-install-recommends curl \
       fontconfig libfontconfig1 libfreetype6 \
       libpng12-0 libjpeg62-turbo \
       libssl1.0.0 libx11-6 libxext6 libxrender1 \
       xfonts-base xfonts-75dpi && \
    curl -L -o /tmp/wkhtmltox.deb $DOWNLOAD_URL && \
    dpkg -i /tmp/wkhtmltox.deb && \
    rm /tmp/wkhtmltox.deb && \
    apt-get purge -y curl && \
    rm -rf /var/lib/apt/lists/*

COPY /app /usr/src/app

RUN mkdir /app && \
    cd /usr/src/app && \
    go build -v -o /app/app && \
    chown -R appuser:appuser /app

USER appuser
WORKDIR /app
EXPOSE 3000

CMD [ "/app/app" ]
