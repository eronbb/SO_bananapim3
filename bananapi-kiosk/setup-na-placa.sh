#!/bin/bash
# Alternativa sem compilar: rode NA PLACA, ja com o Armbian oficial (Banana Pi M3) instalado e com internet.
# Uso: copie esta pasta inteira para a placa e rode: sudo ./setup-na-placa.sh
set -e
cd "$(dirname "$0")"
rm -rf /tmp/overlay && cp -r userpatches/overlay /tmp/overlay
ON_BOARD=1 bash userpatches/customize-image.sh noble x bananapim3 no
echo "Pronto. Reinicie: sudo reboot"
