#! /usr/bin/env python
# -*- coding: utf-8 -*-

import os

cwd = os.path.dirname(__file__) #os.getcwd()
app_root = os.path.dirname(cwd)
app_rundata = '%s/rundata/' % app_root
app_log = '%slog/' % app_root
app_dump = '%sdump/dump.' % app_rundata
app_leveldb_path = '%s/lvdb/' % app_rundata

LOGGING = {
    'version': 1,
    'disable_existing_loggers': True,
    'formatters': {
        'verbose': {
            'format': '%(asctime)s[htbh-%(levelname)s]: %(message)s',
            'datefmt': '[%Y-%m-%d %H:%M:%S]',
            },
        },
    'handlers': {
        'file_request': {
            'level': 'DEBUG',
            'class': 'logging.handlers.RotatingFileHandler',
            'formatter': 'verbose',
            'filename': os.path.join(app_root, 'log', 'hthb.log'),
            'maxBytes': 1024 * 1024 * 10,
            'backupCount': 10,
            },
        },
    'loggers': {
        'hthb': {
            'handlers': ['file_request'],
            'level': 'INFO',
            'propagate': True,
            },
        }
    }

LOGNAME = 'hthb'

site_cl = {'cat_url' : ''}

try:
    from local_setting import *
except Exception, e:
    print str(e)
    pass
