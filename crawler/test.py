#! /usr/bin/env python
# -*- coding: utf-8 -*-

import helper.helper as hp
import helper.cfg as cfg
import sources.yles as yles

if __name__ == '__main__':
    ilog, wlog, elog = hp.get_loggers()
    ilog('this is the log content', 'test_log')
    y = yles.yles()
    print y.go()

