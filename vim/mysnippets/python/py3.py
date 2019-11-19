PY_MAJOR, PY_MINOR = sys.version_info[0:2]
if not ((PY_MAJOR == 2 and PY_MINOR >= 6) or (PY_MAJOR == 3 and PY_MINOR >= 3) or PY_MAJOR > 3):
    sys.exit('This scripts requires Python >= 2.6 or >= 3.3; '
             'your version of Python is ' + sys.version)
