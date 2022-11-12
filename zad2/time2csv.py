import argparse
import pandas as pd
import re


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument('k1', type=int)
    parser.add_argument('k2', type=int)
    parser.add_argument('input', type=str)
    args = parser.parse_args()

    output = args.input + '.csv'

    with open(args.input) as f:
        txt = f.read().strip().split('\n')

    times = [float(re.search(r'(\d+\.\d+) total$', t).group(1)) for t in txt]
    ns = [2**k for k in range(args.k1, args.k2 + 1)]

    df = pd.DataFrame({'n': ns, 'time': times})
    df.to_csv(output, index=False)


if __name__ == '__main__':
    main()
