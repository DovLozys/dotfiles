#!/bin/bash
# usage: sudo DUR=180 ./sweep.sh EPP:PL1:PL2 [EPP:PL1:PL2 ...]
RAPL=/sys/class/powercap/intel-rapl/intel-rapl:0; R=$RAPL/energy_uj
DUR=${DUR:-180}
setepp(){ for p in /sys/devices/system/cpu/cpufreq/policy*; do echo $1 > $p/energy_performance_preference; done; }
setpl(){ echo $(($1*1000000)) > $RAPL/constraint_0_power_limit_uw; echo $(($2*1000000)) > $RAPL/constraint_1_power_limit_uw; }
for spec in "$@"; do
  IFS=: read epp pl1 pl2 <<<"$spec"
  setepp $epp; setpl $pl1 $pl2
  echo "== EPP $epp, PL1 ${pl1}W, PL2 ${pl2}W"
  sleep 5
  for i in $(seq 1 12); do timeout $DUR sh -c 'while :; do :; done' & done
  t=0; sp=0; st=0; n=0
  while [ $t -lt $DUR ]; do
    e0=$(cat $R); sleep 15; e1=$(cat $R); t=$((t+15))
    pc=$(cat /sys/devices/system/cpu/cpufreq/policy{0,1,2,3}/scaling_cur_freq | awk '{s+=$1} END{printf "%d", s/NR/1000}')
    ec=$(cat /sys/devices/system/cpu/cpufreq/policy{8,9,10,11}/scaling_cur_freq | awk '{s+=$1} END{printf "%d", s/NR/1000}')
    tp=$(( $(cat /sys/class/thermal/thermal_zone*/temp | sort -n | tail -1)/1000 ))
    printf "  t+%3ds  P %4d MHz  E %4d MHz  %2d°C  fan %5s  %5.1f W\n" $t $pc $ec $tp \
      "$(sensors 2>/dev/null | awk '/^fan1/{print $2}')" "$(echo "($e1-$e0)/15/1000000" | bc -l)"
    if [ $t -ge 120 ] && [ $t -lt $DUR ]; then sp=$((sp+pc)); st=$((st+tp)); n=$((n+1)); fi
  done
  wait
  [ $n -gt 0 ] && echo "  steady-state (t>=120s): P-core avg $((sp/n)) MHz, $((st/n))°C"
  echo "  cooling 45s..."; sleep 45
done
tuned-adm profile balanced-cool
echo "restored balanced-cool"
