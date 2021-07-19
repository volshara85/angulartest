FROM nginx:latest

WORKDIR /angular

RUN rm /etc/nginx/conf.d/default.conf

COPY nginx/static.conf /etc/nginx/conf.d/
COPY /dist .
 
