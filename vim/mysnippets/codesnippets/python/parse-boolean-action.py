class BooleanAction(argparse.Action):
    def __init__(self, option_strings, dest, **kwargs):
        super(BooleanAction, self).__init__(option_strings, dest, nargs=0, **kwargs)

    def __call__(self, parser, namespace, values, option_string: str):
        setattr(
            namespace, self.dest, False if option_string.startswith("--no") else True
        )