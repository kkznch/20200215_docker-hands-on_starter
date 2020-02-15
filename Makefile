# Laravel の設定とか初期設定してくれるコマンド
# php-fpm コンテナが起動しているときに実行できるよ
init:
	docker-compose exec php-fpm ash -c ' \
		chmod -R 777 /app/storage && \
		composer install && \
		cp .env.example .env && \
		php artisan key:generate && \
		php artisan storage:link'
