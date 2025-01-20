#!/bin/sh

SERIAL_NUMBER="5FD325C5E8AF4A8D"

check_usb_device() {
    for dev in /sys/bus/usb/devices/*; do
        if [ -e "$dev/serial" ]; then
            SERIAL=$(cat "$dev/serial")
            if [ "$SERIAL" = "$SERIAL_NUMBER" ]; then
                return 0
            fi
        fi
    done
    return 1
}

main() {
    echo "Проверка наличия USB-устройства с серийным номером $SERIAL_NUMBER..." > /dev/console
    if check_usb_device; then
        echo "Устройство найдено. Продолжаем загрузку." > /dev/console
        return 0
    fi

    echo "Устройство не найдено. Ожидание подключения..." > /dev/console
    for i in $(seq 30 -1 1); do
        echo "Осталось $i секунд..." > /dev/console
        sleep 1
        if check_usb_device; then
            echo "Устройство подключено. Продолжаем загрузку." > /dev/console
            return 0
        fi
    done

    echo "Таймер истек. Выключение системы." > /dev/console
    poweroff
}

main

