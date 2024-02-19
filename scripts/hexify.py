
import base58
import sys

def hexify(value):
    return base58.b58decode(bytes(value, 'ascii')).hex()[:-8]


def main():
    for arg in sys.argv[1:]:
        print(f"{arg} {hexify(arg)}")


if __name__ == "__main__":
    main()


 