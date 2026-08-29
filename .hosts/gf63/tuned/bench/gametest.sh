#!/bin/bash
# run while the game is running. 3 phases x 12s. restores the tuned profile at the end.
RAPL=/sys/class/powercap/intel-rapl/intel-rapl:0; R=$RAPL/energy_uj
setepp(){ for p in /sys/devices/system/cpu/cpufreq/policy*; do echo $1 > $p/energy_performance_preference; done; }
setpl(){ echo $(($1*1000000)) > $RAPL/constraint_0_power_limit_uw; echo $(($2*1000000)) > $RAPL/constraint_1_power_limit_uw; }
phase(){
  echo "== $1"; sleep 4
  for i in 1 2; do
    e0=$(cat $R); sleep 4; e1=$(cat $R)
    f=$(cat /sys/devices/system/cpu/cpufreq/policy{0,1,2,3}/scaling_cur_freq | sort -n | awk '{a[NR]=$1} END{printf "P-cores %d..%d MHz", a[1]/1000, a[NR]/1000}')
    g=$(nvidia-smi --query-gpu=utilization.gpu,power.draw,clocks.gr --format=csv,noheader,nounits | awk -F', ' '{printf "GPU %s%% %sW %sMHz", $1,$2,$3}')
    printf "  %s  %2d°C  %5.1f W  |  %s\n" "$f" $(( $(cat /sys/class/thermal/thermal_zone*/temp | sort -n | tail -1)/1000 )) "$(echo "($e1-$e0)/4/1000000" | bc -l)" "$g"
  done
}
phase "current: EPP 160, 38/48 W"
setepp balance_performance; phase "EPP balance_performance, 38/48 W"
setpl 55 200;               phase "EPP balance_performance, 55/200 W (stock)"
setepp performance;         phase "EPP performance, 55/200 W"
echo "throttle: pkg=$(cat /sys/devices/system/cpu/cpu0/thermal_throttle/package_throttle_count) core0=$(cat /sys/devices/system/cpu/cpu0/thermal_throttle/core_throttle_count)  shift=$(cat /sys/devices/platform/msi-ec/shift_mode)"
tuned-adm profile balanced-cool; echo "restored balanced-cool"
