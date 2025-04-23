server {
    listen 80;
    server_name nginx.asadsite.kozow.com;

    root /var/www/asadsite.kozow.com;
    index html/nginx.html; 
    
    # return 301 https://$host$request_uri;
}

server {
    listen 443 ssl;

    ssl_certificate /etc/letsencrypt/live/asadsite.kozow.com/fullchain.pem;
    ssl_certificate_key /etc/letsencrypt/live/asadsite.kozow.com/privkey.pem;

    root /var/www/asadsite.kozow.com;
    index html/nginx.html; 
}