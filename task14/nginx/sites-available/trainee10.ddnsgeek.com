server {
    listen 8000;
    
    location /content1 {
        proxy_pass http://localhost:9090/;
    }

    location = /music {
        return 301 /music/song.mp3;
    }

    location /music {
        alias /var/www/trainee10.ddnsgeek.com/music/;
        add_header Content-Disposition 'attachment; filename="song.mp3"';
        types { audio/mpeg mp3; }
	satisfy any;
        allow all;
    }

    location /info.php {
        proxy_pass http://localhost:8090/info.php;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
    }

    location /secondserver {
        proxy_pass https://httpbin.org/;
    }
}