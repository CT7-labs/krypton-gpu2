import json
import random

with open("demo1.json", "r") as jsonfile:
    mapjson = json.loads(jsonfile.read())

tiles = mapjson["layers"][0]["data"]

with open("tilemap.hex", "w") as tilemap:
    
    for i in range(8192):
        tilemap.write(f"{tiles[i] - 1:02X}\n")

"""
with open("tilerom.hex", "w") as f:
    for i in range(2048):
        f.write(f"{random.randint(0,256):02X}\n")
"""

with open("tilepalette.hex", "w") as f:
    for i in range(8192):
        x = i % 64
        y = i // 64
        if not (19 <= x <= 53 and 7 <= y <= 27):  # Outside the bounding box
            f.write(f"{random.randint(0, 4):01X}\n")
        elif y == 27 and 52 > x > 20:
            f.write(f"2\n")
        else:  # Inside the bounding box
            f.write("00\n")