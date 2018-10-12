FROM gcr.io/cloud-marketplace-tools/k8s/deployer_envsubst:v0.6.2

# Provide registry prefix and tag for default values for images.
ARG REGISTRY
ARG TAG

RUN mkdir -p /data/manifest
ADD schema.yaml /data/
ADD scripts/* /data/scripts/

RUN apt update && apt install -y curl/stable

RUN /data/scripts/install-$TAG.sh
RUN $HOME/.linkerd2/bin/linkerd install -l linkerd-namespace > /data/manifest/linkerd.yaml.template
RUN sed -i 's/linkerd-namespace/$NAMESPACE/g' /data/manifest/linkerd.yaml.template
RUN cat /data/schema.yaml \
    | env -i "REGISTRY=$REGISTRY" "TAG=$TAG" envsubst \
    > /data/schema.yaml.new \
    && mv /data/schema.yaml.new /data/schema.yaml
