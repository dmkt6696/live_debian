#!/bin/bash
# Требования: установленный live-build, права root

# Конфигурационный файл для управления списком пакетов
CONFIG_FILE="packages.list"
# Директория для сборки
BUILD_DIR="debian-live-build"
# Имя выходного ISO файла
OUTPUT_ISO="debian-live.iso"
# Лог файл
LOG_FILE="build.log"

# Функция для логирования
log() {
    echo "$(date '+%Y-%m-%d %H:%M:%S') - $1" | tee -a $LOG_FILE
}

# Проверка наличия конфигурационного файла
if [ ! -f "$CONFIG_FILE" ]; then
    log "Конфигурационный файл $CONFIG_FILE не найден!"
    exit 1
fi

# Создание директории для сборки
mkdir -p $BUILD_DIR
cd $BUILD_DIR

# Инициализация конфигурации live-build
log "Инициализация конфигурации live-build..."
lb config noauto \
    --architectures amd64 \
    --binary-images iso-hybrid \
    --distribution bullseye \
    --mirror-bootstrap "http://deb.debian.org/debian" \
    --mirror-chroot "http://deb.debian.org/debian" \
    --archive-areas "main contrib non-free" \
    --bootappend-live "boot=live components"

# Добавление пакетов из конфигурационного файла
log "Добавление пакетов из $CONFIG_FILE..."
mkdir -p config/package-lists/
cp ../$CONFIG_FILE config/package-lists/custom.list.chroot

# Начало сборки
log "Начало сборки live образа..."
lb build 2>&1 | tee -a $LOG_FILE

# Проверка успешности сборки
if [ -f "live-image-amd64.hybrid.iso" ]; then
    log "Сборка успешно завершена."
    # Перемещение ISO файла в родительскую директорию
    mv live-image-amd64.hybrid.iso ../$OUTPUT_ISO
    log "ISO файл создан: $OUTPUT_ISO"
    cp /build/debian-live.iso /output/debian-live.iso
    cp /build/debian-live-build/build.log /output/build.log
else
    log "Ошибка при сборке live образа."
    exit 1
fi

# Очистка временных файлов
log "Очистка временных файлов..."
lb clean --all

log "Процесс звершен."
