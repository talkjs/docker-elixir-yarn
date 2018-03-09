FROM elixir:1.6.0

# Prerequisites for `google-cloud-platform` - https://cloud.google.com/sdk/downloads#apt-get
RUN export CLOUD_SDK_REPO="cloud-sdk-stretch" \
    && echo "deb http://packages.cloud.google.com/apt $CLOUD_SDK_REPO main" | tee -a /etc/apt/sources.list.d/google-cloud-sdk.list  \ 
    && curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add - 

# Prerequisites for `docker`
RUN curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add - \
	&& add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"

# Prerequisites for `node`
RUN curl -sL https://deb.nodesource.com/setup_8.x | bash -

# Prerequisites for `yarn` - https://yarnpkg.com/lang/en/docs/install/#linux-tab
RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - \
	&& echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list

# Installs
RUN rm -rf /var/cache/apt \
	&& apt-get update -y \
    && apt-get install -y nodejs yarn google-cloud-sdk docker-ce

# Install docker-compose
RUN curl -L https://github.com/docker/compose/releases/download/1.16.1/docker-compose-`uname -s`-`uname -m` -o /usr/local/bin/docker-compose \
    && chmod +x /usr/local/bin/docker-compose
