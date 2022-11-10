FROM node:16.16.0-alpine

WORKDIR /usr/src/app

COPY ./dist/apps/video-streaming .

RUN yarn install --prod

COPY ./videos ./videos

CMD node ./main.js
