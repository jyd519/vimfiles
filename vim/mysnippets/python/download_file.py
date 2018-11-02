def download_file(url, target):
    f = urllib2.urlopen(url)
    with open(target, "wb") as code:
        code.write(f.read())
