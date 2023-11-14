FROM elixir:1.15.4-otp-25-slim

RUN apt-get update -y \
    && apt-get -y install apt-transport-https curl lsb-release unzip ca-certificates gnupg

# Prerequisites for `node`
RUN mkdir -p /etc/apt/keyrings \
    && curl -fsSL https://deb.nodesource.com/gpgkey/nodesource-repo.gpg.key | gpg --dearmor -o /etc/apt/keyrings/nodesource.gpg \
    && echo "deb [signed-by=/etc/apt/keyrings/nodesource.gpg] https://deb.nodesource.com/node_18.x nodistro main" | tee /etc/apt/sources.list.d/nodesource.list

# Prerequisites for `yarn` - https://yarnpkg.com/lang/en/docs/install/#linux-tab
RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - \
    && echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list

# install chrome
RUN curl --silent --show-error --location --fail --retry 3 --output /tmp/google-chrome-stable_current_amd64.deb https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb \
    && (dpkg -i /tmp/google-chrome-stable_current_amd64.deb || apt-get -fy install)  \
    && rm -rf /tmp/google-chrome-stable_current_amd64.deb \
    && sed -i 's|HERE/chrome"|HERE/chrome" --disable-setuid-sandbox --no-sandbox|g' \
    "/opt/google/chrome/google-chrome"

# Prerequisites for php8
RUN wget -O /etc/apt/trusted.gpg.d/php.gpg https://packages.sury.org/php/apt.gpg \
    && sh -c 'echo "deb https://packages.sury.org/php/ $(lsb_release -sc) main" > /etc/apt/sources.list.d/php.list'

# Installs
RUN apt-get update -y \
    && apt-get install -y php8.2 nodejs=18.15.0-1nodesource1 yarn \
    && apt reinstall fonts-noto-color-emoji
