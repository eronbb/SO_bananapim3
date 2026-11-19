#!/bin/bash
# Roda dentro do chroot da imagem durante o build do Armbian.
RELEASE=$1; LINUXFAMILY=$2; BOARD=$3; BUILD_DESKTOP=$4
set -e

Main() {
  export DEBIAN_FRONTEND=noninteractive
  apt-get update

  # Python (Ubuntu noble = 3.12) + splash. Pacotes extras: edite overlay/app/apt-packages.txt
  EXTRA=$(grep -vE '^\s*(#|$)' /tmp/overlay/app/apt-packages.txt 2>/dev/null | tr '\n' ' ' || true)
  apt-get install -y --no-install-recommends python3 python3-venv python3-pip python3-tk plymouth plymouth-themes \
    xserver-xorg-core xserver-xorg-input-libinput xserver-xorg-video-fbdev xinit x11-xserver-utils $EXTRA
  python3 --version

  # ---- Pasta do aplicativo ----
  mkdir -p /opt/app
  cp -r /tmp/overlay/app/. /opt/app/
  python3 -m venv --system-site-packages /opt/app/venv
  if grep -qvE '^\s*(#|$)' /opt/app/requirements.txt 2>/dev/null; then
    /opt/app/venv/bin/pip install --no-cache-dir -r /opt/app/requirements.txt
  fi

  # ---- Servico que inicia o app ----
  cp /tmp/overlay/meuapp.service /etc/systemd/system/meuapp.service
  systemctl enable meuapp.service
  # A logo so sai depois que o app foi iniciado
  mkdir -p /etc/systemd/system/plymouth-quit.service.d
  cat > /etc/systemd/system/plymouth-quit.service.d/wait-app.conf <<EOT
[Unit]
After=meuapp.service
EOT
  systemctl disable getty@tty1.service 2>/dev/null || true

  # ---- Logo em tela cheia (Plymouth) ----
  T=/usr/share/plymouth/themes/bananalogo
  mkdir -p $T
  cp /tmp/overlay/plymouth/* $T/
  cp /tmp/overlay/logo.png $T/logo.png
  plymouth-set-default-theme -R bananalogo

  # ---- Boot silencioso com splash ----
  ENVF=/boot/armbianEnv.txt
  touch $ENVF
  sed -i '/^bootlogo=/d;/^extraargs=/d;/^console=/d' $ENVF
  echo "bootlogo=true" >> $ENVF
  echo "console=none" >> $ENVF
  echo "extraargs=quiet splash loglevel=0 vt.global_cursor_default=0 plymouth.ignore-serial-consoles" >> $ENVF

  # ---- Pula o assistente de primeiro boot ----
  if [ -z "$ON_BOARD" ]; then
  cat > /root/.not_logged_in_yet <<EOT
PRESET_NET_CHANGE_DEFAULTS="1"
PRESET_NET_ETHERNET_ENABLED="1"
PRESET_NET_WIFI_ENABLED="0"
SET_LANG_BASED_ON_LOCATION="n"
PRESET_LOCALE="pt_BR.UTF-8"
PRESET_TIMEZONE="America/Sao_Paulo"
PRESET_ROOT_PASSWORD="bananapi"
EOT
  fi

  # ---- Emagrecer ----
  systemctl mask apt-daily.timer apt-daily-upgrade.timer motd-news.timer ModemManager.service 2>/dev/null || true
  apt-get purge -y snapd cloud-init 2>/dev/null || true
  apt-get autoremove -y --purge
  apt-get clean
  rm -rf /var/lib/apt/lists/* /usr/share/doc/* /usr/share/man/* /var/cache/apt/*
}

Main "$@"
