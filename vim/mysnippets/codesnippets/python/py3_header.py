#!/usr/bin/env python
# -*- coding: utf-8 -*-
from __future__ import print_function
from __future__ import division
from __future__ import absolute_import
import os
import sys
import errno
import stat
import subprocess
import shutil
import glob


PY_MAJOR, PY_MINOR = sys.version_info[ 0 : 2 ]
if not ( ( PY_MAJOR == 2 and PY_MINOR >= 6 ) or
         ( PY_MAJOR == 3 and PY_MINOR >= 3 ) or
         PY_MAJOR > 3 ):
  sys.exit( 'This scripts requires Python >= 2.6 or >= 3.3; '
            'your version of Python is ' + sys.version )

script_path = os.path.dirname(os.path.realpath(__file__))
