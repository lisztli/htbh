#! /usr/bin/env python
# -*- coding: utf-8 -*-

import os
import logging
import logging.config
import datetime
import urllib
import urllib2
import hashlib
import subprocess
import json

import leveldb

from wordpress_xmlrpc import Client, WordPressPost
from wordpress_xmlrpc.methods.posts import NewPost
import xmlrpclib

import cfg


loggers = [None, None, None]

def get_loggers():
    """

    Arguments:
    - `logger`:
    """
    global loggers
    if loggers[0]:
        return loggers
    logging.config.dictConfig(cfg.LOGGING)
    logger = logging.getLogger(cfg.LOGNAME)
    return map(lambda lg: lambda l, path='':
                   (lg('[logtype=%s]%s' % (path, fmt_msg_for_log(l))), l)[1],
               map(lambda a: getattr(logger, a),
                   ('info', 'warning', 'error')))

def fmt_msg_for_log(msg):
    """

    Arguments:
    - `msg`:
    """
    if isinstance(msg, str):
        return '[info=%s]' % msg
    elif isinstance(msg, dict):
        return '[%s]' % ']['.join('%s=%s' % (k,
                                             isinstance(v, str) and
                                             v or json.dumps(v))
                                  for k, v in msg.iteritems())
    else:
        return '[info=%s]' % json.dumps(msg)


def get_remote(url, param=None):
    """get or post to url for some result

    Arguments:
    - `url`:
    - `param`: post to url if param is not blank
    """

    if param:
        data = urllib.urlencode(param)
        req = urllib2.Request(url, data)
    else:
        req = urllib2.Request(url)
    try:
        resp = urllib2.urlopen(req, timeout=1)
        cnt = resp.read()
        return 1, cnt
    except Exception, e:
        return -1, str(e)

def invoke_until_succ(validator, n, f, *args, **kwargs):
    """invork function f n times with args and kwargs if until succ

    Arguments:
    - `validator`
    - `f`:
    - `n`:
    - `*args`:
    - `**kwargs`:
    """
    rst = f(*args, **kwargs)
    if validator(rst) or (n < 1):
        return rst

    return invoke_until_succ(validator, (n-1), f, *args, **kwargs)

def md5sum(cnt):
    """
    
    Arguments:
    - `str`:
    """
    m = hashlib.md5()
    m.update(cnt)
    return m.hexdigest()

def get_remote_by_wget(url, local):
    """
    
    Arguments:
    - `url`:
    - `local`:
    """
    return ''

def save_loc(url, tgt):
    """ save the file on server to local disk
    
    Arguments:
    - `url`:
    - `tgt`:
    """
    local_file = '%simgs/%s' % (cfg.app_rundata, tgt)
    tgt_fd = os.path.dirname(local_file)
    if not os.path.exists(tgt_fd):
        os.makedirs(tgt_fd)
    succ = invoke_until_succ(lambda succ: True,
                             3,
                             #lambda u: urllib.urlretrieve(u, local_file),
                             lambda u: subprocess.call(['wget', u,
                                                    '-O', local_file]),
                             #get_remote,
                            url)
    succ = 1
    if succ < 0:
        return succ, cnt
    return succ, '/wpimg/' + tgt


def filter_history(url):
    """
    
    Arguments:
    - `url`:
    """
    db = leveldb.LevelDB('%s/url_his' % cfg.app_leveldb_path)
    url = url[url.find('read'):]
    try:
        db.Get(url)
        print 'gotcha', url
        return False
    except:
        db.Put(url, 'done')
    return True

def post_to_wp(host, u, p, title, content):
    """
    
    Arguments:
    - `addr`:
    - `u`:
    - `p`:
    - `title`:
    - `content`:
    """
    if not content:
        return ''
    wp = Client(host, u, p)
    post = WordPressPost()
    post.title = title
    post.content = content
    #post.tags = tags
    #post.categories = cates
    postid =  wp.call(NewPost(post))
    ilog, _, _ = get_loggers()
    ilog({'title': title,
          'postid': postid},
         'POST_SUCCESS')
