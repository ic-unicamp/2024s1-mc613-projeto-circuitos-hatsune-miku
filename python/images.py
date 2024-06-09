import numpy as np
from PIL import Image

path = input("Digite o caminho: ")

img = Image.open(path).convert('RGB')
arr = np.array(img)

# R = list()
# G = list()
# B = list()

R = open("R_out.txt", "w")
G = open("G_out.txt", "w")
B = open("B_out.txt", "w")

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

R.close()
G.close()
B.close()
