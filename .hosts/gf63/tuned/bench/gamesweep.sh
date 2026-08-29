#!/bin/bash
# in-game sweep: sudo ./gamesweep.sh PL1:MAXGHZ ...   e.g. 38:4.4 35:4.4 32:4.4 38:3.5
# each phase 24s (4s settle + 5 samples). restores balanced-cool at the end.
RAPL=/sys/class/powercap/intel-rapl/intel-rapl:0; R=$RAPL/energy_uj
for spec in "$@"; do
  IFS=: read pl1 ghz <<<"$spec"
  echo $((pl1*1000000)) > $RAPL/constraint_0_power_limit_uw
  for p in /sys/devices/system/cpu/cpufreq/policy*; do echo $(echo "$ghz*1000000/1" | bc) > $p/scaling_max_freq; done
  echo "== PL1 ${pl1} W, max ${ghz} GHz"; sleep 4
  for i in 1 2 3 4 5; do
    e0=$(cat $R); sleep 4; e1=$(cat $R)
    f=$(cat /sys/devices/system/cpu/cpufreq/policy{0,1,2,3}/scaling_cur_freq | sort -n | awk '{a[NR]=$1} END{printf "P %d..%d MHz", a[1]/1000, a[NR]/1000}')
    g=$(nvidia-smi --query-gpu=utilization.gpu,power.draw,clocks.gr --format=csv,noheader,nounits | awk -F', ' '{printf "GPU %s%% %sW %sMHz", $1,$2,$3}')
    printf "  %-18s %2d°C  fan %5s  %5.1f W  |  %s\n" "$f" $(( $(cat /sys/class/thermal/thermal_zone*/temp | sort -n | tail -1)/1000 )) "$(sensors 2>/dev/null | awk '/^fan1/{print $2}')" "$(echo "($e1-$e0)/4/1000000" | bc -l)" "$g"
  done
done
for p in /sys/devices/system/cpu/cpufreq/policy*; do cat $p/cpuinfo_max_freq > $p/scaling_max_freq; done
tuned-adm profile balanced-cool; echo "restored balanced-cool"
