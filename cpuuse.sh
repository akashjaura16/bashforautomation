#!/bin/bash
#limits
CPU_LIMIT=20
MEM_LIMIT=85
DISK_LIMIT=90
REPORT="report.txt"
> $REPORT

cpu_usage=$(top -bn1 | grep "Cpu(s)" | awk '{print 100 - $8}')
cpu_int=${cpu_usage%.*}
echo "CPU Usage: $cpu_usage%" >> $REPORT

if [ "$cpu_int" -gt "$CPU_LIMIT" ]; then
  echo "⚠️ High CPU usage detected!" >> $REPORT
fi



#memory
mem_total=$(free -m | grep "Mem:" | awk '{print $2}')
mem_used=$(free -m | grep "Mem:" | awk '{print $3}')
mem_percent=$((mem_used * 100 / mem_total))
echo "memory usage : $mem_percent%" >> $REPORT

if [ "$mem_percent" -gt "$MEM_LIMIT" ]; then
    echo " HIGH memory usage " >> $REPORT
fi
disk_usage=$(df / | awk 'NR==2 {print $5}' | tr -d '%')

if [ "$disk_usage" -gt "$DISK_LIMIT" ]; then
    echo "  High disk usage detected!" >> $REPORT
fi

if [ "$cpu_int" -gt "$CPU_LIMIT" ] || [ "$mem_percent" -gt "$MEM_LIMIT" ] || [ "$disk_usage" -gt "$DISK_LIMIT" ]; then
    mail -s "  ALERT: High System Usage on EC2" akashjaura016@gmail.com < $REPORT

fi
