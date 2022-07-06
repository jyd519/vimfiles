def _ignorepath(path, names):
    if path.endswith('build'):
        return ['tools']
    return []   # nothing will be ignored


def recursive_overwrite(src, dest, ignore=None):
    if not os.path.exists(src):
        return
    if os.path.isdir(src):
        if not os.path.isdir(dest):
            os.makedirs(dest)
        files = os.listdir(src)
        if ignore is not None:
            ignored = ignore(src, files)
        else:
            ignored = set()
        for f in files:
            if f not in ignored:
                recursive_overwrite(os.path.join(src, f),
                                    os.path.join(dest, f),
                                    ignore)
    else:
        shutil.copy(src, dest)

