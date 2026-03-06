import numpy as np
from PIL import Image
import matplotlib.pyplot as plt

def miffilegen(infile, outfname, numrows, numcols):
    img = Image.open(infile).convert('RGB')
    img_resized = img.resize((numcols, numrows), Image.BILINEAR)

    img_np = np.array(img_resized, dtype=np.uint8)  # 0..255

    rows, cols, _ = img_np.shape

    # Convert 8-bit RGB -> 4-bit RGB (0..15)
    img_4bit = img_np >> 4

    # Preview (scale back up so it looks normal on screen)
    preview = (img_4bit << 4).astype(np.uint8)
    plt.imshow(preview)
    plt.axis('off')
    plt.show()

    with open(outfname, 'w') as f:
        f.write(f'-- {rows}x{cols} 12-bit image color values (4-4-4 RGB)\n\n')
        f.write('WIDTH = 12;\n')
        f.write(f'DEPTH = {rows * cols};\n\n')
        f.write('ADDRESS_RADIX = UNS;\n')
        f.write('DATA_RADIX = UNS;\n\n')
        f.write('CONTENT BEGIN\n')

        addr = 0
        for r in range(rows):
            for c in range(cols):
                red   = int(img_4bit[r, c, 0])  # 0..15
                green = int(img_4bit[r, c, 1])  # 0..15
                blue  = int(img_4bit[r, c, 2])  # 0..15

                color = (red << 8) | (green << 4) | blue  # 12-bit packed

                f.write(f'{addr:5d} : {color:4d};\n')
                addr += 1

        f.write('END;\n')

    return outfname, rows, cols

if __name__ == '__main__':
    miffilegen(
        infile='input.png',
        outfname='output128.mif',
        numrows=128,
        numcols=128
    )