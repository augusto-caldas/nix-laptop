{ pkgs }:
with pkgs; [
  moonlight-qt      # Streaming
  prismlauncher     # Minecraft
  ruffle            # Flash

  # PC port
  banjorecomp       # Banjo-Kazooie
  ship-of-harkinian # Ocarina of Time
  2ship2harkinian   # Majora's Mask
  sm64ex            # Mario 64

  # Emulator
  (retroarch.withCores (cores: with cores; [
    # Nintendo
    mesen                  # NES
    bsnes                  # SNES
    mupen64plus-next       # N64
    dolphin                # GameCube / Wii
    sameboy                # GB / GBC
    mgba                   # GBA
    melonds                # NDS
    citra                  # 3DS

    # Sony
    beetle-psx-hw          # PS1
    ppsspp                 # PSP

    # Sega
    genesis-plus-gx        # Genesis / Mega Drive / Sega CD / Master System / Game Gear
    beetle-saturn          # Saturn
    flycast                # Dreamcast

    # Arcade & Classic
    fbneo                  # Arcade
    stella                 # Atari 2600
  ]))
]
