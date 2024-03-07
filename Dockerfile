FROM nginx:latest
COPY ./build /usr/share/nginx/html
COPY ./nginx.conf /etc/nginx/conf.d/default.conf
COPY build/ /usr/share/nginx/html/love-game
EXPOSE 80
ENV SERVER_NAME love-game

CMD ["nginx", "-g", "daemon off;"]
