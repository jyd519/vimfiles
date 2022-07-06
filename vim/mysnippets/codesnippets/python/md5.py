def calc_file_md5(filename):
    with open(filename, 'rb') as f:
        m = hashlib.md5()
        while True:
            data = f.read(128*m.block_size)
            if not data:
                break
            m.update(data)
        return m.hexdigest()
