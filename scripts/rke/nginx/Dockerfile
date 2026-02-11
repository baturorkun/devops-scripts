FROM nginx:stable-alpine
COPY default.conf /etc/nginx/conf.d/
EXPOSE 80
CMD ["sh", "-c", "echo ${CONFIG} > /usr/share/nginx/html/config.json && nginx -g \"daemon off;\""]
