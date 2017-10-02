FROM trenpixster/elixir:1.4.4

# Prerequisites for the `gcloud` (Google Cloud Platform) utility as described in https://cloud.google.com/sdk/downloads#apt-get
RUN export CLOUD_SDK_REPO="cloud-sdk-$(lsb_release -c -s)" \
    && echo "deb http://packages.cloud.google.com/apt $CLOUD_SDK_REPO main" | sudo tee -a /etc/apt/sources.list.d/google-cloud-sdk.list  \ 
    && curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add - 
    
# Install node, gcloud & yarn, respectively 
RUN curl -sL https://deb.nodesource.com/setup_7.x | bash - \
    && apt-get install -y nodejs gcloud \
    && rm -rf /var/cache/apt \
    && npm install -g yarn
