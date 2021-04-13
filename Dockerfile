FROM node:10.15.3-alpine

RUN set -xe \
    && apk add --update


RUN npm install -g @vue/cli
RUN npm install -g yarn

WORKDIR /app
