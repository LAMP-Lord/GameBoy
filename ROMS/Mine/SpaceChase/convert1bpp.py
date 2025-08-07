from PIL import Image
import argparse
import sys

def convert_to_4x4_tile_format(png_file, output_file):
    # Load PNG
    img = Image.open(png_file)
    if img.mode != 'P' or len(img.getpalette()) > 6:  # 2 colors (RGB)
        raise ValueError("PNG must be 1bpp indexed (2 colors)")
    width, height = img.size
    if width % 4 != 0 or height % 4 != 0:
        raise ValueError("Image dimensions must be multiples of 4")
    
    pixels = img.load()
    tiles_x, tiles_y = width // 4, height // 4
    output = bytearray()
    
    # Process block-rows (4 pixels tall)
    for block_row in range(tiles_y):
        # Process tiles in block-row
        for tile_x in range(tiles_x):
            # Encode 4x4 tile (2 bytes)
            byte1 = byte2 = 0
            for row in range(4):
                nibble = 0
                # Get 4 pixels in row
                for col in range(4):
                    pixel = pixels[tile_x * 4 + col, block_row * 4 + row]
                    bit = 1 if pixel == 1 else 0  # Index 1 = text
                    nibble = (nibble << 1) | bit
                # Pack nibble
                if row < 2:
                    byte1 |= nibble << (4 if row == 0 else 0)
                else:
                    byte2 |= nibble << (4 if row == 2 else 0)
            output.extend([byte1, byte2])
    
    # Write output
    with open(output_file, 'wb') as f:
        f.write(output)
    
    return output

if __name__ == "__main__":
    parser = argparse.ArgumentParser(description="Convert PNG to 4x4 tile format.")
    parser.add_argument("input", help="Path to input PNG file")
    parser.add_argument("output", help="Path to output binary file")
    args = parser.parse_args()

    try:
        convert_to_4x4_tile_format(args.input, args.output)
        print(f"Conversion successful: {args.output}")
    except Exception as e:
        print(f"Error: {e}", file=sys.stderr)
        sys.exit(1)