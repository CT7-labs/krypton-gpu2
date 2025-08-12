# Python script to generate a .hex file for 8Kx8 iCE40 BRAM initialization
# Fills 8192 bytes as a 128x64 pixel checkerboard (FF for white, 00 for black)

with open("tilemap.hex", "w") as f:
    for y in range(64):  # 64 rows
        for x in range(128):  # 128 pixels per row
            # Checkerboard: FF if (x[0] ^ y[0]) is 0, 00 if 1
            pixel = 0x01 if (x % 2) ^ (y % 2) == 1 else 0x00
            f.write(f"{pixel:02X}\n")