#! /bin/bash
printf "OS\t\tMemory\t\tTotalRAM\t\tDisk\t\tDisktotal\t\tCPUAvg\t\tCPUCount\n"
OS=$(uname -a |awk '{print$1}')
MEMORY=$(free -m | awk 'NR==2{printf "%.2f%%\t\t", $3*100/$2 }')
TotalRAM=$(grep MemTotal /proc/meminfo | awk '{print $2 / 1024}')
DiskTotal=$(lsblk -dn -o NAME,TYPE,SIZE | awk '/disk/ {sum+=$NF} END {print sum, "GB"}')
UsedStorage=$(df -hl -x tmpfs -x devtmpfs --total | grep -i total|awk '{print $3}')
DISK=$(df -h | awk '$NF=="/"{printf "%s\t\t", $5}')
CPUAvg=$(top -bn1 | grep load | awk '{printf "%.2f%%\t\t\n", $(NF-2)}')
CPUcount=$(lscpu | grep 'CPU(s):' | head -1 | awk '{print $2}')
echo "$OS$MEMORY  $TotalRAM $DISK  $DiskTotal $CPUAvg  $CPUcount"
