def md5sum(filePath, block_size = 8192):
    with open(filePath, 'rb') as fh:
        m = hashlib.md5()
        while True:
            data = fh.read(block_size)
            if not data:
                break
            m.update(data)
        return m.hexdigest()
