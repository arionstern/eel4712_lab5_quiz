# Newman Waters
# Generate MIF file from input image

import numpy as np
from PIL import Image
import matplotlib.pyplot as plt


def miffilegen(infile, outfname, numrows, numcols):
    img = Image.open(infile).convert('RGB')
    img_resized = img.resize((numcols, numrows), Image.BILINEAR)

    img_np = np.array(img_resized, dtype=np.float32)

    rows, cols, _ = img_np.shape

    img_scaled = img_np / 16.0 - 1.0

    plt.imshow(np.clip(img_scaled * 16, 0, 255).astype(np.uint8))
    plt.axis('off')
    plt.show()

    with open(outfname, 'w') as f:
        f.write(f'-- {rows:3d}x{cols:3d} 12bit image color values\n\n')
        f.write('WIDTH = 12;\n')
        f.write(f'DEPTH = {rows * cols:4d};\n\n')
        f.write('ADDRESS_RADIX = UNS;\n')
        f.write('DATA_RADIX = UNS;\n\n')
        f.write('CONTENT BEGIN\n')

        count = 0
        for r in range(rows):
            for c in range(cols):
                red   = int(img_scaled[r, c, 0])
                green = int(img_scaled[r, c, 1])
                blue  = int(img_scaled[r, c, 2])

                color = red * 256 + green * 16 + blue

                f.write(f'{count:4d} : {color:4d};\n')
                count += 1

        f.write('END;\n')

    return outfname, rows, cols


if __name__ == '__main__':
    # You can call the function like this:
    miffilegen(
        infile='src/demo/eric_s.jpg',
        outfname='output.mif',
        numrows=128,
        numcols=128
    ) 
