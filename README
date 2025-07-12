# Krypton V2
Krypton is a tile-mode graphics controller
designed to be a companion to Argon

# Specs
- 12kB memory
- 80x60 tiles (256x unique tiles)
- tiles are 1bpp
- each tile has 8 bits of flags:
    - 4-bit palette index
    - horizontal flip
    - vertical flip
    - 2 reserved bits
- 16 palettes of 2x RGB565 colors

### If FFs need to be conserved...
    Upper 8 palettes have the same ON color as the lower 8, but unique OFF colors