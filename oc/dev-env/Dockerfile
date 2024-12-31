FROM php:8.2-apache

ENV DIR_OPENCART='/var/www/html/'
ENV DIR_STORAGE='/storage/'
ENV DIR_CACHE=${DIR_STORAGE}'cache/'
ENV DIR_DOWNLOAD=${DIR_STORAGE}'download/'
ENV DIR_LOGS=${DIR_STORAGE}'logs/'
ENV DIR_SESSION=${DIR_STORAGE}'session/'
ENV DIR_UPLOAD=${DIR_STORAGE}'upload/'
ENV DIR_IMAGE=${DIR_OPENCART}'image/'

RUN apt-get update \
  && apt-get install -y \
                     wait-for-it \
                     unzip \
                     libfreetype6-dev \
                     libjpeg62-turbo-dev \
                     libpng-dev \
                     libzip-dev \
                     libcurl3-dev \
					 libwebp-dev \
  && docker-php-ext-configure gd --with-freetype --with-jpeg --with-webp \
  && docker-php-ext-install -j$(nproc) gd zip mysqli curl \
  && docker-php-ext-enable gd zip mysqli curl

RUN a2enmod rewrite
