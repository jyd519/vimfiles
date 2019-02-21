def ParseArgs():
    parser = argparse.ArgumentParser(description="Build Packages for MacOS")
    parser.add_argument("-v", "--verbose", action="store_true")
    parser.add_argument("-q", "--quiet", action="store_true")
    parser.add_argument("x", type=int, help="the base")
    parser.add_argument("y", type=int, help="the exponent")
    return parser.parse_args()
