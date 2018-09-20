1. Create network for environment:  
docker network create laravel-environment

2. Build image in the current directory (where Dockerfile is):  
Don't forget to set UID/GID in Dockerfile to local user!  
docker build -t laravel-environment .

3. Creating containers for developing laravel application:  
-v set mounts local directory to docker container  
cd LARAVEL_APP_DIR  
docker run --net laravel-environment -v $(pwd):/var/www --name container-name laravel-environment  
docker run --name redis --net laravel-environment redis

4. Install mysql  
docker run --net laravel-environment -v laravel-environment:/var/lib/mysql --name mysql -e MYSQL_ROOT_PASSWORD=secret_password -d mysql:5.7  
docker container cp scheme.sql mysql:/root/scheme.sql  
docker container exec -it mysql mysql -u root -p -e 'CREATE DATABASE db_name'  
docker container exec -it mysql bash  
mysql -u root -p db_name < /root/scheme.sql  
exit  

5. Install .env & composer dependencies:  
docker container exec -ti container-name bash  
cd /var/www  
composer update  
cp .env.example .env  
php artisan key:generate 

6. In .env file of laravel set:  
REDIS_HOST=redis  
REDIS_PASSWORD=null  
REDIS_PORT=6379  
DB_CONNECTION=mysql  
DB_HOST=mysql  
DB_PORT=3306  
DB_DATABASE=db_name  
DB_USERNAME=root  
DB_PASSWORD=secret_password

