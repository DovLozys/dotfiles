#!/bin/bash
# one-shot CPU/GPU power status. sudo for package watts; everything else works unprivileged.
for d in /sys/class/powercap/intel-rapl:0 /sys/class/powercap/intel-rapl-mmio:0; do
  printf "%-16s PL1 %2d W  PL2 %3d W\n" "$(basename $d)" $(( $(cat $d/constraint_0_power_limit_uw)/1000000 )) $(( $(cat $d/constraint_1_power_limit_uw)/1000000 ))
done
echo "shift=$(cat /sys/devices/platform/msi-ec/shift_mode 2>/dev/null)  EPP=$(cat /sys/devices/system/cpu/cpufreq/policy0/energy_performance_preference)  tuned=$(cat /etc/tuned/active_profile)"
echo "P-cores: $(cat /sys/devices/system/cpu/cpufreq/policy{0,1,2,3}/scaling_cur_freq | awk '{printf "%d ", $1/1000}')MHz  $(( $(cat /sys/class/thermal/thermal_zone*/temp | sort -n | tail -1)/1000 ))°C  fan $(sensors 2>/dev/null | awk '/^fan1/{print $2}') RPM"
if [ -r /sys/class/powercap/intel-rapl:0/energy_uj ]; then e0=$(cat /sys/class/powercap/intel-rapl:0/energy_uj); sleep 2; e1=$(cat /sys/class/powercap/intel-rapl:0/energy_uj); printf "pkg %.1f W\n" "$(echo "($e1-$e0)/2/1000000" | bc -l)"; fi
nvidia-smi --query-gpu=utilization.gpu,power.draw,clocks.gr,temperature.gpu --format=csv,noheader,nounits 2>/dev/null | awk -F', ' '{printf "GPU %s%%  %s W  %s MHz  %s°C\n",$1,$2,$3,$4}'
