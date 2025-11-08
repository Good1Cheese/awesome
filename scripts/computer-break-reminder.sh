#!/bin/bash

# === Настройки ===
ACTIVE_LIMIT_MS=$((60 * 60 * 1000))      # 1.0 активного времени
WARNING_OFFSET_MS=$((5 * 60 * 1000))     # за 5 минут до блокировки — предупреждение
IDLE_THRESHOLD_MS=$((4 * 60 * 1000))     # >4 мин бездействия — не активен
CHECK_INTERVAL_SEC=60
BREAK_DURATION_MIN=15                    # длительность перерыва
MESSAGE_BASE="Сходи на улицу погулять, броу!"

# === Проверки ===
if ! command -v xprintidle &> /dev/null; then
    echo "Ошибка: установи xprintidle"
    exit 1
fi

if ! command -v betterlockscreen &> /dev/null; then
    echo "Ошибка: установи betterlockscreen"
    exit 1
fi

ACTIVE_TIME=0
WARNING_SHOWN=false

while true; do
    IDLE=$(xprintidle)
    if [ "$IDLE" -lt "$IDLE_THRESHOLD_MS" ]; then
        ACTIVE_TIME=$((ACTIVE_TIME + CHECK_INTERVAL_SEC * 1000))

        # --- Проверка: пора ли показать предупреждение? ---
        WARNING_THRESHOLD=$((ACTIVE_LIMIT_MS - WARNING_OFFSET_MS))
        if [ "$ACTIVE_TIME" -ge "$WARNING_THRESHOLD" ] && [ "$ACTIVE_TIME" -lt "$ACTIVE_LIMIT_MS" ] && [ "$WARNING_SHOWN" = false ]; then
            MINUTES_LEFT=$(( (ACTIVE_LIMIT_MS - ACTIVE_TIME) / 60000 ))
            notify-send "⏳ Скоро перерыв!" "Через ~${MINUTES_LEFT} мин — гулять! Приготовься." -t 8000
            WARNING_SHOWN=true
        fi

        # --- Проверка: пора ли блокировать? ---
        if [ "$ACTIVE_TIME" -ge "$ACTIVE_LIMIT_MS" ]; then
            # Рассчитываем время возврата
            RETURN_TS=$(( $(date +%s) + BREAK_DURATION_MIN * 60 ))
            RETURN_TIME=$(date -d "@$RETURN_TS" +"%H:%M")

            FULL_MESSAGE="${MESSAGE_BASE}... Вернёшься в ${RETURN_TIME}"

            notify-send "🚶 Перерыв!" "$FULL_MESSAGE" -t 5000
            sleep 3

            betterlockscreen --lock --text "$FULL_MESSAGE" --show-layout

            # Сброс состояния
            ACTIVE_TIME=0
            WARNING_SHOWN=false
        fi
    else
        # Если пользователь ушёл надолго — сбрасываем предупреждение (чтобы не спамило при возврате)
        WARNING_SHOWN=false
    fi

    sleep "$CHECK_INTERVAL_SEC"
done
