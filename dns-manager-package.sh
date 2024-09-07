#!/bin/bash

# Crea la struttura delle directory per il pacchetto
mkdir -p dns-manager_1.0-1/DEBIAN
mkdir -p dns-manager_1.0-1/usr/bin
mkdir -p dns-manager_1.0-1/usr/share/applications
mkdir -p dns-manager_1.0-1/usr/share/icons/hicolor/scalable/apps

# Crea il file di controllo
cat > dns-manager_1.0-1/DEBIAN/control << EOL
Package: dns-manager
Version: 1.0-1
Section: net
Priority: optional
Architecture: all
Depends: bash, zenity, network-manager
Maintainer: Your Name amore.fobico@gmail.com
Description: DNS Manager
 A graphical application to easily manage
 DNS settings on Linux systems.
 .
 Un'applicazione grafica per gestire facilmente
 le impostazioni DNS su sistemi Linux.
EOL

# Copia lo script principale
cp /home/fabio/Applications/dns-manager.sh dns-manager_1.0-1/usr/bin/dns-manager
chmod +x dns-manager_1.0-1/usr/bin/dns-manager

# Crea il file .desktop
cat > dns-manager_1.0-1/usr/share/applications/dns-manager.desktop << EOL
[Desktop Entry]
Name=DNS Manager
Name[it]=Gestore DNS
Comment=Manage your DNS settings
Comment[it]=Gestisci le tue impostazioni DNS
Exec=/usr/bin/dns-manager
Icon=/usr/share/icons/hicolor/scalable/apps/dns-manager.svg
Terminal=false
Type=Application
Categories=Network;System;
EOL

# Crea l'icona SVG
cat > dns-manager_1.0-1/usr/share/icons/hicolor/scalable/apps/dns-manager.svg << EOL
<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 100 100">
  <defs>
    <linearGradient id="grad1" x1="0%" y1="0%" x2="100%" y2="100%">
      <stop offset="0%" style="stop-color:#4a90e2;stop-opacity:1" />
      <stop offset="100%" style="stop-color:#3498db;stop-opacity:1" />
    </linearGradient>
  </defs>
  
  <!-- Sfondo circolare -->
  <circle cx="50" cy="50" r="45" fill="url(#grad1)" />
  
  <!-- Simbolo DNS stilizzato -->
  <path d="M30 35 Q50 25 70 35 Q50 45 30 35 Z" fill="#ffffff" />
  <path d="M30 50 Q50 40 70 50 Q50 60 30 50 Z" fill="#ffffff" />
  <path d="M30 65 Q50 55 70 65 Q50 75 30 65 Z" fill="#ffffff" />
  
  <!-- Simbolo di connessione -->
  <circle cx="50" cy="50" r="5" fill="#ffffff" />
  <path d="M50 45 L50 30 M45 35 L50 30 L55 35" stroke="#ffffff" stroke-width="3" fill="none" />
  <path d="M50 55 L50 70 M45 65 L50 70 L55 65" stroke="#ffffff" stroke-width="3" fill="none" />
  
  <!-- Bordo dell'icona -->
  <circle cx="50" cy="50" r="45" fill="none" stroke="#ffffff" stroke-width="2" />
</svg>
EOL

# Crea il file postinst
cat > dns-manager_1.0-1/DEBIAN/postinst << EOL
#!/bin/bash
chmod +x /usr/bin/dns-manager
update-desktop-database
EOL

chmod +x dns-manager_1.0-1/DEBIAN/postinst

# Crea il pacchetto
dpkg-deb --build dns-manager_1.0-1

echo "Pacchetto creato: dns-manager_1.0-1.deb"
