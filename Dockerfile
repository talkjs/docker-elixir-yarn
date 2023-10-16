FROM elixir:1.13.3

RUN apt-get update -y \
    && apt-get -y install apt-transport-https curl lsb-release unzip ca-certificates gnupg

# Prerequisites for `google-cloud-platform` - https://cloud.google.com/sdk/downloads#apt-get
RUN export CLOUD_SDK_REPO="cloud-sdk-$(lsb_release -c -s)" \
    && echo "deb http://packages.cloud.google.com/apt $CLOUD_SDK_REPO main" | tee -a /etc/apt/sources.list.d/google-cloud-sdk.list  \
    && curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add -

# Prerequisites for `docker`
RUN curl -fsSL https://download.docker.com/linux/debian/gpg | apt-key add - \
    && echo "deb https://download.docker.com/linux/debian $(lsb_release -cs) stable" | tee -a /etc/apt/sources.list.d/docker.list

# Prerequisites for `node`
RUN mkdir -p /etc/apt/keyrings \
    && curl -fsSL https://deb.nodesource.com/gpgkey/nodesource-repo.gpg.key | sudo gpg --dearmor -o /etc/apt/keyrings/nodesource.gpg \
    && echo "deb [signed-by=/etc/apt/keyrings/nodesource.gpg] https://deb.nodesource.com/node_18.x nodistro main" | sudo tee /etc/apt/sources.list.d/nodesource.list

# Prerequisites for `yarn` - https://yarnpkg.com/lang/en/docs/install/#linux-tab
RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - \
    && echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list

# install firefox
ENV PATH /firefox:$PATH
RUN FIREFOX_URL="https://download-installer.cdn.mozilla.net/pub/firefox/releases/85.0.2/linux-x86_64/en-US/firefox-85.0.2.tar.bz2" \
    FIREFOX_SHA256="98763f4b1526811967d71e1bbb9552a9a3fd877321ecb497083b9e313b528c31" \
    && curl --silent --show-error --location --fail --retry 3 --output /tmp/firefox.tar.bz2 $FIREFOX_URL \
    && echo "$FIREFOX_SHA256 /tmp/firefox.tar.bz2" | sha256sum -c \
    && tar -jxf /tmp/firefox.tar.bz2 \
    && rm /tmp/firefox.tar.bz2

# install chrome
RUN curl --silent --show-error --location --fail --retry 3 --output /tmp/google-chrome-stable_current_amd64.deb https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb \
    && (dpkg -i /tmp/google-chrome-stable_current_amd64.deb || apt-get -fy install)  \
    && rm -rf /tmp/google-chrome-stable_current_amd64.deb \
    && sed -i 's|HERE/chrome"|HERE/chrome" --disable-setuid-sandbox --no-sandbox|g' \
    "/opt/google/chrome/google-chrome"

# Install php7
RUN apt-get -y install apt-transport-https lsb-release ca-certificates \
    && wget -O /etc/apt/trusted.gpg.d/php.gpg https://packages.sury.org/php/apt.gpg \
    && sh -c 'echo "deb https://packages.sury.org/php/ $(lsb_release -sc) main" > /etc/apt/sources.list.d/php.list' \
    && apt-get update \
    && apt-get install php7.2 -y


# Installs
RUN apt-get update -y \
    && apt-get install -y nodejs=18.15.0-1nodesource1 yarn google-cloud-sdk docker-ce \
    && apt reinstall fonts-noto-color-emoji

# Install docker-compose
RUN curl -L https://github.com/docker/compose/releases/download/1.28.2/docker-compose-`uname -s`-`uname -m` -o /usr/local/bin/docker-compose \
    && chmod +x /usr/local/bin/docker-compose
