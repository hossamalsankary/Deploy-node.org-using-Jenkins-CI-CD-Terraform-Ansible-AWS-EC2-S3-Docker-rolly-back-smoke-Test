FROM node:16-alpine

ENV NODE_ENV='development'

WORKDIR /opt


COPY ["package*.json", "./"]


RUN npm install 


COPY . .


CMD npm  start