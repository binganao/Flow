echo "  █████▒██▓     ▒█████   █     █░"
echo "▓██   ▒▓██▒    ▒██▒  ██▒▓█░ █ ░█░"
echo "▒████ ░▒██░    ▒██░  ██▒▒█░ █ ░█ "
echo "░▓█▒  ░▒██░    ▒██   ██░░█░ █ ░█ "
echo "░▒█░   ░██████▒░ ████▓▒░░░██▒██▓ "
echo " ▒ ░   ░ ▒░▓  ░░ ▒░▒░▒░ ░ ▓░▒ ▒  "
echo " ░     ░ ░ ▒  ░  ░ ▒ ▒░   ▒ ░ ░  "
echo " ░ ░     ░ ░   ░ ░ ░ ▒    ░   ░  "
echo "           ░  ░    ░ ░      ░    "
echo "                                 "

echo "Author: Bingan <github.com/binganao>"

touch all.txt
while true; do
    echo "[FLOW] `date` - Starting scan"
    echo "[FLOW] `date` - Starting scan" | notify -silent
    /bin/sh -c "/script/init.sh"
    echo "[FLOW] `date` New assets will be scanned in an hour"
    echo "[FLOW] `date` New assets will be scanned in an hour" | notify -silent
    sleep 3600
done