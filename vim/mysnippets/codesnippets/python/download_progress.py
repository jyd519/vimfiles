def download(url, path, text=None):
    if text is None:
        text = path

    with open(path, "wb") as local_file:
        print("Downloading %s to %s" % (url, path))
        web_file = urlopen(url)
        info = web_file.info()
        if hasattr(info, "getheader"):
            file_size = int(info.getheaders("Content-Length"))
        else:
            file_size = int(info.get("Content-Length"))
        downloaded_size = 0
        block_size = 4096

        not_ci = sys.stdout.isatty()

        while True:
            buf = web_file.read(block_size)
            if not buf:
                break

            downloaded_size += len(buf)
            local_file.write(buf)

            if not_ci:
                percent = downloaded_size * 100.0 / file_size
                status = "\r%s  %10d  [%3.1f%%]" % (text, downloaded_size, percent)
                print(status, end=" ")

        if not_ci:
            print("%s done." % (text))
        else:
            print()
    return path
