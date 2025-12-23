{ pkgs }:
with pkgs; [
  # Browsers
  brave
  firefox
  tor-browser
  # Media
  cheese
  feishin
  jellyfin-media-player  
  komikku
  mpv
  obs-studio
  streamlink
  vesktop
  vlc
  yt-dlp
  # Editors
  drawing
  gimp
  inkscape
  joplin-desktop
  kdePackages.kdenlive
  krita
  libreoffice
  libresprite
  sweethome3d.application
  video-trimmer
  # Games
  moonlight-qt
  ruffle
  (retroarch.withCores (cores: with cores; [
        beetle-psx  # PS1
        mgba        # GBA
        bsnes       # SNES
  ]))
  # Tools
  evolution
  eyedropper
  fragments
  nextcloud-client
  gnome-decoder
  gnome-tweaks
  woeusb
]
