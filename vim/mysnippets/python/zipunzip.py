def unzip_file(zipf, target):
    subprocess.check_call(['7z', 'x', '-o'+target, zipf])

def zipdir(path, zipf):
    subprocess.check_call(['7z', 'a', zipf, '.', '-xr!.DS_Store'], cwd=path)
