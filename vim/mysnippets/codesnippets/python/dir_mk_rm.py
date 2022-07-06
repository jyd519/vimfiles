import os
import shutil
import errno
import stat
import glob

def mkdirs(path):
    try:
        os.makedirs(path)
    except OSError as exc:
        if exc.errno == errno.EEXIST and os.path.isdir(path):
            pass


def remove_readonly(func, path, _):
    "Clear the readonly bit and reattempt the removal"
    os.chmod(path, stat.S_IWRITE)
    func(path)

def rm_rf(path):
  try:
    shutil.rmtree(path, onerror=remove_readonly)
    # shutil.rmtree(path, ignore_errors=True)
  except OSError as e:
    if e.errno != errno.ENOENT:
      raise


def rmfiles(pattern):
  for f in glob.glob(pattern):
    os.remove(f)

