#!/usr/bin/env python

from __future__ import print_function
from __future__ import division
from __future__ import unicode_literals
from __future__ import absolute_import

import os
import subprocess
import sys
import os.path as p
import glob

PY_MAJOR, PY_MINOR, PY_PATCH = sys.version_info[ 0 : 3 ]
if not ( ( PY_MAJOR == 2 and PY_MINOR == 7 and PY_PATCH >= 1 ) or
         ( PY_MAJOR == 3 and PY_MINOR >= 4 ) or
         PY_MAJOR > 3 ):
  sys.exit( 'YouCompleteMe requires Python >= 2.7.1 or >= 3.4; '
            'your version of Python is ' + sys.version )

DIR_OF_THIS_SCRIPT = p.dirname( p.abspath( __file__ ) )
