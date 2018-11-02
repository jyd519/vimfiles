def hex_str(b):
  res = ''
  for d in b:
    res += "%02x" % ord(d)
  return res
