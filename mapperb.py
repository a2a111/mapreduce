import sys

def mapper():
    for line in sys.stdin:
        wordline = line.strip().split()
        wordkey = wordline[0]
        wordvalue = wordline[1]

        print "%s\tb\t%s" % (wordkey, wordvalue)

if __name__ == "__main__":
    mapper()
