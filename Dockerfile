FROM node:12.22 as builder

WORKDIR /angular
COPY ./angulartest/package*.json .

RUN npm install

COPY ./angulartest .

RUN npm run build

FROM nginx:latest

WORKDIR /angular
RUN rm /etc/nginx/conf.d/default.conf
COPY nginx/static.conf /etc/nginx/conf.d
COPY --from=builder /angular/dist .
