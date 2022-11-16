FROM node:16-alpine

ENV NODE_ENV='development'

WORKDIR /opt


COPY ["package.json", "./"]


RUN npm install -f


COPY . .


CMD npm run dev