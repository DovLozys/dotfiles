#!/bin/bash
set -e
cp -r "$(dirname "$0")/profiles/balanced-cool" /etc/tuned/profiles/
# desktop power-mode picker: Balanced -> balanced-cool, Performance -> stock balanced
sed -i "s/^balanced=balanced$/balanced=balanced-cool/; s/^performance=throughput-performance$/performance=balanced/" /etc/tuned/ppd.conf
systemctl restart tuned-ppd
tuned-adm profile balanced-cool
sleep 2
echo "active: $(tuned-adm active | cut -d: -f2)"
echo "EPP=$(cat /sys/devices/system/cpu/cpufreq/policy0/energy_performance_preference)  PL1=$(( $(cat /sys/class/powercap/intel-rapl/intel-rapl:0/constraint_0_power_limit_uw)/1000000 ))W  PL2=$(( $(cat /sys/class/powercap/intel-rapl/intel-rapl:0/constraint_1_power_limit_uw)/1000000 ))W"
tuned-adm verify | tail -1
