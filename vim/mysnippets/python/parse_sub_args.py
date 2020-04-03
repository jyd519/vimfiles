def ParseArgs():
    parser = argparse.ArgumentParser(description='cargo tools for addding examples')
    subparsers = parser.add_subparsers(title="commands", dest="command")

    parser_foo = subparsers.add_parser('foo')
    parser_foo.add_argument('-x', type=int, default=1)
    parser_foo.add_argument('y', type=float)
    parser_foo.set_defaults(func=foo)

    parser_bar = subparsers.add_parser('bar')
    parser_bar.add_argument('z')
    parser_bar.set_defaults(func=bar)

    args = parser.parse_args()
    if not args.command:
        args.print_help()
        return False

    args.func(args)
    return True


def foo(args):
    print(args.x * args.y)

def bar(args):
    print('((%s))' % args.z)
