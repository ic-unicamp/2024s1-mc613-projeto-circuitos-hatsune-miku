import numpy as np
from PIL import Image

path = input("Digite o nome da imagem: ")

w, h = Image.open(f"{path}.png").size

print(f"Img:{w * h}")
print()

with open(f"R_out_{path}.txt", 'r') as file:
    contents = file.read()
    print(f"R:{len(contents)}") 

with open(f"G_out_{path}.txt", 'r') as file:
    contents = file.read()
    print(f"G:{len(contents)}")  

with open(f"B_out_{path}.txt", 'r') as file:
    contents = file.read()
    print(f"B:{len(contents)}")

with open(f"Simplified_out_{path}.txt", 'r') as file:
    contents = file.read()
    print(f"Simplified:{len(contents)}")