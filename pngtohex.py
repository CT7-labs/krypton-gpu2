from PIL import Image
import sys
import os

def main():
    if len(sys.argv) != 2:
        print("Usage: python script.py <input.png>")
        sys.exit(1)
    
    input_png = sys.argv[1]
    output_hex = os.path.splitext(input_png)[0] + '.hex'
    
    # Open the image
    img = Image.open(input_png)
    width, height = img.size
    
    # Define supported image sizes
    supported_sizes = [
        (135, 135),  # 16x16 grid of 8x8 tiles with 1px margins
        (287, 71)    # 32x8 grid of 8x8 tiles with 1px margins
    ]
    
    tile_size = 8
    margin = 1
    
    # Check if image size is supported
    is_valid_size = False
    tiles_per_row = 0
    tiles_per_col = 0
    
    for w, h in supported_sizes:
        if width == w and height == h:
            is_valid_size = True
            tiles_per_row = (width + margin) // (tile_size + margin)
            tiles_per_col = (height + margin) // (tile_size + margin)
            break
    
    if not is_valid_size:
        print(f"Error: Image dimensions {width}x{height} not supported. Supported sizes: {supported_sizes}")
        sys.exit(1)
    
    # Function to determine if a pixel is set (black/1) or unset (white/0)
    def is_set(pixel):
        if isinstance(pixel, int):  # Grayscale
            return pixel < 128
        else:  # RGB or RGBA
            r, g, b = pixel[:3]
            brightness = (r + g + b) // 3
            return brightness < 128
    
    with open(output_hex, 'w') as f:
        for row in range(tiles_per_col):
            for col in range(tiles_per_row):
                start_x = col * (tile_size + margin)
                start_y = row * (tile_size + margin)
                
                for y in range(tile_size):
                    byte = 0
                    for x in range(tile_size):
                        pixel = img.getpixel((start_x + x, start_y + y))
                        if is_set(pixel):
                            byte |= (1 << (7 - x))  # MSB is leftmost pixel
                    f.write(f"{byte ^ 0xFF:02X}\n")

if __name__ == "__main__":
    main()