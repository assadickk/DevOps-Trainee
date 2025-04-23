server {
    listen 80 default_server;
    server_name nginx.asadsite.kozow.com ;

    root /var/www/asadsite.kozow.com;
    index html/nginx.html; 

    # return 301 https://$host$request_uri;
}