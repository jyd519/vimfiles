@contextlib.contextmanager
def TemporaryDirectory():
  temp_dir = tempfile.mkdtemp()
  try:
    yield temp_dir
  finally:
    shutil.rmtree( temp_dir )

