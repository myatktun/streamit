FROM node:16.16.0-alpine

WORKDIR /usr/src/app

COPY ./dist/apps/aws-storage/package.json .

RUN yarn install --prod

COPY ./dist/apps/aws-storage .

CMD node ./main.js
