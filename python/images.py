import numpy as np
from PIL import Image

path = input("Digite o nome da imagem: ")

img = Image.open(f"{path}.png").convert('RGB')
arr = np.array(img)

# R = list()
# G = list()
# B = list()

R = open(f"R_out_{path}.txt", "w")
G = open(f"G_out_{path}.txt", "w")
B = open(f"B_out_{path}.txt", "w")
S = open(f"Simplified_out_{path}.txt", "w")

for i in range(len(arr)):
    for j in range(len(arr[0])):
        if arr[i][j][0] == 0:
            R.write('0')
        else:
            R.write('1')
        if arr[i][j][1] == 0:
            G.write('0')
        else:
            G.write('1')
        if arr[i][j][2] == 0:
            B.write('0')
        else:
            B.write('1')
        if not arr[i][j][0] == 0 or not arr[i][j][1] == 0 or not arr[i][j][2] == 0:
            S.write('1')
        else:
            S.write('0')

R.close()
G.close()
B.close()
S.close()
