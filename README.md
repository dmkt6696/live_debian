# Сборка Debian Live ISO с помощью Docker


Этот репозиторий содержит скрипты и Docker-конфигурацию для автоматизированной сборки Debian Live ISO.


---


## Оглавление


1. [Требования](#требования)

2. [Установка Docker](#установка-docker)

4. [Сборка Docker-образа](#сборка-docker-образа)

5. [Запуск сборки Debian Live ISO](#запуск-сборки-debian-live-iso)

6. [Получение ISO-образа](#получение-iso-образа)

7. [Настройка списка пакетов](#настройка-списка-пакетов)

8. [Логирование](#логирование)



---


## Требования


- Установленный Docker.

- Доступ к интернету для загрузки пакетов.


---


## Установка Docker


Если Docker не установлен, выполните следующие команды:


### Linux (Debian/Ubuntu):


```bash

sudo apt-get update

sudo apt-get install docker.io

sudo systemctl start docker

sudo systemctl enable docker

```


---


## Сборка Docker-образа


Соберите Docker-образ для сборки Debian Live ISO:


```bash

sudo docker build -t debian-live-build .

```


---


## Запуск сборки Debian Live ISO


Запустите контейнер для сборки ISO-образа:


```bash

sudo docker run -it --rm \

    --privileged \

    -v $(pwd)/output:/output \

    debian-live-build

```


После завершения сборки ISO-файл будет сохранен в директорию `./output`.


---


## Получение ISO-образа


ISO-файл будет автоматически скопирован в директорию `./output` на вашем хосте. Проверьте его наличие:


```bash

ls -l ./output/debian-live.iso

```


---


## Настройка списка пакетов


Чтобы изменить список пакетов, которые будут установлены в ISO, отредактируйте файл `packages.list`. Каждый пакет должен быть указан на новой строке. Например:


```plaintext

vim

htop

git

curl

```


---


## Логирование


Логи сборки выводятся в консоль. Если вы хотите сохранить логи в файл, перенаправьте вывод:


```bash

sudo docker run -it --rm \

    --privileged \

    -v $(pwd)/output:/output \

    debian-live-build > build.log 2>&1

```


Логи будут сохранены в файл `build.log`.


---


### Примечания


- Для сборки требуется подключение к интернету.
