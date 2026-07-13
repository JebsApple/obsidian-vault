---
tags:
  - linux/security
  - hardening
  - checklist
  - Referencia
created: 2026-07-12
---

# Linux Hardening Checklist 2026

## SSH

```bash
# /etc/ssh/sshd_config
PermitRootLogin no
PasswordAuthentication no
PubkeyAuthentication yes
AllowUsers youruser
LoginGraceTime 30
MaxAuthTries 3
X11Forwarding no
Protocol 2
```

- Keys: `ssh-keygen -t ed25519` (not RSA)
- Disable empty passwords: `PermitEmptyPasswords no`

## Firewall

```bash
# UFW
ufw default deny incoming
ufw default allow outgoing
ufw allow 22/tcp    # SSH
ufw allow 80/tcp    # HTTP
ufw allow 443/tcp   # HTTPS
ufw enable
```

O `firewalld` en RHEL/Fedora. Solo puertos necesarios.

## Fail2Ban

```bash
apt install fail2ban
systemctl enable fail2ban
# Custom filter en /etc/fail2ban/jail.local
maxretry = 3
bantime = 3600
findtime = 600
```

## Kernel sysctl

```bash
# /etc/sysctl.d/99-hardening.conf
net.ipv4.conf.all.accept_redirects = 0
net.ipv4.conf.all.send_redirects = 0
net.ipv4.conf.all.accept_source_route = 0
net.ipv4.icmp_echo_ignore_broadcasts = 1
net.ipv4.tcp_syncookies = 1
kernel.randomize_va_space = 2
fs.suid_dumpable = 0
```

`sysctl --system` para aplicar.

## Audit

- **Lynis**: `lynis audit system` — score + recomendaciones
- **Logwatch**: reporte diario por email
- **rkhunter/chkrootkit**: rootkit detection

## Updates automáticos

```bash
apt install unattended-upgrades
dpkg-reconfigure -plow unattended-upgrades
```

## Disk encryption

- LUKS en particiones sensibles
- `cryptsetup luksFormat /dev/sdX`
- `cryptsetup open /dev/sdX myvolume`

## BIOS/UEFI

- Secure Boot habilitado
- Deshabilitar boot desde USB/external
- Password en BIOS

## Backup: Regla 3-2-1

- 3 copias, 2 medios diferentes, 1 offsite
- Test restoration periódicamente
- Scripts con `borgbackup` o `restic`
