# gf63 — MSI Thin GF63 12VE (Fedora)

Machine-specific backups. Nothing here is sourced automatically; apply by hand after cloning.

## tuned: balanced-cool

Cooler CPU profile for the MSI GF63 12VE (i5-12450H). Fedora `balanced` plus
EPP 160 and a 38 W sustained / 48 W burst RAPL cap. Measured 2026-08-29 under
3-min all-core load: stock 3.5 GHz / 58 W / 97 °C (throttling) → 2.9 GHz / 38 W / 86 °C flat.

    sudo ~/.hosts/gf63/tuned/install.sh

Maps the desktop power-mode picker: Balanced → balanced-cool, Performance → stock balanced.
Revert/removal commands are in the header of `tuned/profiles/balanced-cool/tuned.conf`.
