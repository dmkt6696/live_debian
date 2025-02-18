# Используем официальный образ Debian Bullseye
FROM debian:bullseye

# Устанавливаем необходимые пакеты
RUN apt-get update && apt-get install -y \
    live-build \
    debian-archive-keyring \
    sudo \
    && rm -rf /var/lib/apt/lists/*

# Рабочая директория
WORKDIR /build

# Копируем скрипт сборки и конфигурационные файлы
COPY build-live-debian.sh /build/
COPY packages.list /build/

# Устанавливаем права на выполнение скрипта
RUN chmod +x /build/build-live-debian.sh

# Точка монтирования для автоматического копирования ISO
VOLUME /output

# Команда, которая запускается при старте контейнера
CMD ["./build-live-debian.sh"]
