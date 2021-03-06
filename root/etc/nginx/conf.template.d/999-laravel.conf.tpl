server {
	listen 80 default_server;
	listen 81 default_server http2 proxy_protocol;
	listen [::]:80 default_server ipv6only=on;

	root /var/www/app/public;
	index index.php index.html index.htm;

	server_name <SERVER_URL>;

	location / {
		include /etc/nginx/include/cors-options.conf;

		try_files $uri $uri/ /index.php$is_args$args;
	}

	location ~ \.php$ {
		include /etc/nginx/include/cors-php.conf;

		try_files $uri /index.php =404;
		fastcgi_split_path_info ^(.+\.php)(/.+)$;
		fastcgi_pass unix:/var/run/php/php7.0-fpm.sock;
		fastcgi_index index.php;
		fastcgi_param SCRIPT_FILENAME /var/www/app/public/index.php;
		include fastcgi_params;
		include /etc/nginx/include/proxy-https.conf;
		include /etc/nginx/include/proxy-ip-rancher.conf;
		include /etc/nginx/include/harden-http-poxy.conf;
	}
}

