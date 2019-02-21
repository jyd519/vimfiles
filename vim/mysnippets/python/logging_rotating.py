import logging
from logging.handlers import RotatingFileHandler

level = logging.DEBUG
formatter = logging.Formatter('%(asctime)-12s [%(levelname)s] %(message)s')
logging.basicConfig(format='%(asctime)s [%(levelname)s] %(message)s',
                    level=level)

rthandler = RotatingFileHandler('app.log',
        maxBytes=10*1024*1024,backupCount=5)
rthandler.setLevel(level)
rthandler.setFormatter(formatter)
logging.getLogger('').addHandler(rthandler)
# logging.getLogger("requests").setLevel(logging.WARNING)
# logging.getLogger("urllib3").setLevel(logging.WARNING)
