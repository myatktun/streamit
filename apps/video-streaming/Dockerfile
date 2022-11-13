FROM node:16.16.0-alpine

WORKDIR /usr/src/app

COPY ./dist/apps/video-streaming/package.json .

RUN yarn install --prod

COPY ./dist/apps/video-streaming .

COPY ./videos ./videos

CMD node ./main.js
