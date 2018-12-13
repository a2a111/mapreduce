import sys

def reducer():
    valueA = ''
    for line in sys.stdin:
        wordkey, flag, wordvalue = line.strip().split('\t')
        if flag == 'a':
            valueA = wordvalue
        elif flag == 'b':
            valueB = wordvalue
            print "%s\t%s\t%s" % (wordkey,valueA,valueB)
            valueA = ''

if __name__ == "__main__":
    reducer()
