# gf63 — MSI Thin GF63 12VE (Fedora)

Machine-specific backups. Nothing here is sourced automatically; apply by hand after cloning.

## tuned: balanced-cool

Cooler CPU profile for the MSI GF63 12VE (i5-12450H). Fedora `balanced` plus
a 38 W sustained / 48 W burst RAPL cap. Measured 2026-08-29 under
3-min all-core load: stock 3.5 GHz / 58 W / 97 °C (throttling) → 2.9 GHz / 38 W / 86 °C flat.

    sudo ~/.hosts/gf63/tuned/install.sh

Maps the desktop power-mode picker: Balanced → balanced-cool, Performance → stock balanced.
Revert/removal commands are in the header of `tuned/profiles/balanced-cool/tuned.conf`.

`tuned/bench/`: `status.sh` (one-shot power/clock/GPU readout — note the two RAPL
interfaces, the firmware `intel-rapl-mmio` one wins if lower), `sweep.sh EPP:PL1:PL2 ...`
(3-min all-core load per candidate), `gametest.sh` (EPP/PL A/B while a game runs).
Do not set msi-ec `shift_mode=comfort`: with the dGPU active the EC clamps the CPU to
30 W via the MMIO limit. Default (`sport`, reads as `unknown (192)`) is fine; reboot clears it.
