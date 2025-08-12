import random

with open("tilemap.hex", "w") as f:
    for i in range(8192):
        f.write(f"{random.choice([47,92]):02X}\n")
"""
with open("tilerom.hex", "w") as f:
    for i in range(2048):
        f.write(f"{random.randint(0,256):02X}\n")

with open("tilepalette.hex", "w") as f:
    for i in range(8192):
        f.write(f"{random.randint(0,4):01X}\n")"""