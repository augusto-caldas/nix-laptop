{ pkgs }:
with pkgs; [
  # Browsers
  chromium
  firefox
  tor-browser
  # Media
  cheese
  feishin
  jellyfin-media-player
  komikku
  mpv
  obs-studio
  vesktop
  vlc
  # Editors
  drawing
  gimp
  inkscape
  kdenlive
  krita
  joplin-desktop
  libreoffice
  sweethome3d.application
  video-trimmer
  # Games
  moonlight-qt
  (retroarch.override {
    cores = with libretro; [
        beetle-psx  # PS1
        mgba        # GBA
        bsnes       # SNES
      ];
    }
  )
  # Tools
  evolution
  eyedropper
  fragments
  nextcloud-client
  gnome-decoder
  gnome-tweaks
]