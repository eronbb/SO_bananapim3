# Banana Pi M3 - kiosk Python (Tkinter)
1. Troque `userpatches/overlay/logo.png` pela sua logo (PNG, de preferencia 1920x1080).
2. Seu script: `userpatches/overlay/app/main.py` (ou depois, no cartao: /opt/app/main.py).
3. `./build.sh` (PC Linux x86_64). A imagem sai em armbian-build/output/images/.
4. Grave num cartao SD (balenaEtcher). Para gravar na eMMC de 8GB: boot pelo SD e rode `armbian-install`.
Login via SSH/serial: root / bananapi (troque a senha!).
O app roda como root dentro de um X minimo (sem desktop). Use root.attributes("-fullscreen", True) no Tk.
Se o X nao abrir a tela, veja: journalctl -u meuapp e /var/log/Xorg.0.log

## Sem PC Linux
**A) GitHub Actions (gratis):** crie um repositorio no GitHub, envie esta pasta, va em Actions > "Gerar imagem Banana Pi M3" > Run workflow. Em 1-2 h baixe o .img.xz em Artifacts e grave com o balenaEtcher.
**B) Sem compilar:** baixe o Armbian oficial do Banana Pi M3 (armbian.com/bananapi-m3), grave no SD, de boot, copie esta pasta para a placa e rode `sudo ./setup-na-placa.sh`.
