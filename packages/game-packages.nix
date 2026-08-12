{ pkgs }:
with pkgs; [
  moonlight-qt      # Streaming
  prismlauncher     # Minecraft
  ruffle            # Flash

  # Recompiled
  n64recomp
  bk_rom_compressor
  banjorecomp       # Banjo-Kazooie
  sm64ex            # Mario 64
  shipwright        # Ocarina of Time
  _2ship2harkinian  # Majora's Mask

  # Steam
  steam
  steam-run
  steam-unwrapped

  # Emulator
  (retroarch.withCores (cores: with cores; [
    # Nintendo
    mesen               # NES
    bsnes               # SNES
    mupen64plus         # N64
    dolphin             # GameCube / Wii
    sameboy             # GB / GBC
    mgba                # GBA
    melonds             # NDS
    citra               # 3DS

    # Sony
    beetle-psx-hw        # PS1
    ppsspp               # PSP

    # Sega
    blastem              # Genesis / Mega Drive
    beetle-saturn        # Saturn
    flycast              # Dreamcast

    # Arcade
    mame                # Arcade
    stella              # Atari 2600
  ]))
]
