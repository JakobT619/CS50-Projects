from cs50 import get_int, get_string

while True:
    h = get_int("Height: ")
    if h > 0 and h < 9:
        break

for i in range(h):
    for space in range(h - i - 1):
        print(" ", end="")
    for j in range(i + 1):
        print("#", end="")
    print()
