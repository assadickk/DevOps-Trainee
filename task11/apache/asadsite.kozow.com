<VirtualHost *:80>
    DocumentRoot "/var/www/asadsite.kozow.com/apache.html"
    ServerName apache.asadsite.kozow.com
</VirtualHost>