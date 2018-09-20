FROM ubuntu:18.04
ENV TZ Europe/Bratislava

# CHANGE GID/UID to LOCAL USER OWNING FILES OF LARAVEL APP
RUN groupadd -g 1000 docker-apache
RUN useradd -u 1000 -g 1000 docker-apache
ENV APACHE_RUN_USER docker-apache
ENV APACHE_RUN_GROUP docker-apache


RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone
RUN apt-get update && apt-get install -y curl apache2 libapache2-mod-php7.2 php7.2-mbstring php-redis php-tokenizer php7.2-json php7.2-curl php7.2-xml php7.2-mysql php7.2-zip zip unzip git && apt-get clean && rm -rf /var/lib/apt/lists/*
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/bin --filename=composer
RUN rm /etc/apache2/sites-enabled/000-default.conf
RUN rm -rf /var/www/*
COPY configs/virtualhost.conf /etc/apache2/sites-available/virtualhost.conf
RUN a2ensite virtualhost && a2enmod rewrite
RUN ln -sf /dev/stdout /var/log/apache2/access.log \
    && ln -sf /dev/stderr /var/log/apache2/error.log
ENV APACHE_LOG_DIR /var/log/apache2
ENV APACHE_PID_FILE /var/run/apache2/apache2.pid
ENV APACHE_RUN_DIR /var/run/apache2
ENV APACHE_LOCK_DIR /var/lock/apache2
ENV APACHE_LOG_DIR /var/log/apache2

EXPOSE 80

CMD ["/usr/sbin/apache2", "-D", "FOREGROUND"]
