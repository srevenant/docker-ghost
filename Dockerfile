FROM node:6-alpine

ENV NODE_ENV production
ENV GHOST_BASE /app/ghost/
ENV GHOST_CONTENT /app/ghost/content

#ENV GHOST_VERSION 1.17.3

ENV GHOST_VERSION 0.11.12

WORKDIR $GHOST_BASE

COPY Ghost-$GHOST_VERSION.zip $WORKDIR

RUN apk add --no-cache \
		ca-certificates \
		openssl &&\
    apk add --no-cache --virtual build-deps \
		gcc \
		make \
		python \
		unzip &&\
    unzip Ghost-$GHOST_VERSION.zip &&\
    rm -rf Ghost-$GHOST_VERSION.zip &&\
    npm install --production &&\
	apk del build-deps &&\
	npm cache clean &&\
    rm -rf /tmp/npm* &&\
	mkdir -p $GHOST_CONTENT &&\
	ln -s $GHOST_CONTENT/config.js $GHOST_BASE/config.js

VOLUME $GHOST_CONTENT

ARG BUILD_VERSION
RUN echo $BUILD_NUMBER && apk --no-cache update

EXPOSE 2368
CMD ["node", "index.js"]
