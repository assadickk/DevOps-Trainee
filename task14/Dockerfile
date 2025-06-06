FROM nginx:alpine
COPY ./www/trainee10.ddnsgeek.com/html /usr/share/nginx/html
COPY ./nginx/nginx.conf /etc/nginx/nginx.conf
COPY ./nginx/sites-available/* /etc/nginx/conf.d/
COPY ./www /var/www
RUN chown -R nginx:nginx /var/www && \
    chmod -R 755 /var/www


# FROM httpd:alpine
# COPY ./apache2/sites-available/php-info.conf /usr/local/apache2/conf/httpd.conf