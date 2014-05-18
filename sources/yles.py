#! /user/bin/env python
# -*- coding: utf-8 -*-

import BeautifulSoup
import feedparser
import datetime

import helper.cfg as cfg
import helper.helper as hp

class yles():
    cat_url = cfg.site_cl['cat_url']
    def get_targets(self):
        succ, resp = hp.invoke_until_succ(lambda (rst, resp): rst > 0,
                                          3,
                                          hp.get_remote,
                                          self.__class__.cat_url)
        if succ < 1:
            return succ, resp
        #resp =  unicode(resp,'GB2312','ignore').encode('utf-8','ignore')
        
        d = feedparser.parse(resp)
        rsts = map(lambda item: map(lambda a: getattr(item, a).encode('utf8'),
                                           ['title', 'link']),
                   d.entries)
        ilog, wlog, elog = hp.get_loggers()
        map(lambda (title, link): ilog({'title': title,
                                        'link': link}, 'GET_CATEGORIES'),
            rsts)
        return rsts

    def get_page(self, url):
        """
        
        Arguments:
        - `self`:
        - `url`:
        """
        ilog, wlog, elog = hp.get_loggers()
        succ, resp = hp.invoke_until_succ(lambda (rst, resp): rst > 0,
                                          3,
                                          hp.get_remote,
                                          url)
        ilog({'url': url, 'succ': succ}, 'RETRIEVE_PAGE')
        if succ < 1:
            return succ, resp
        try:
            resp =  unicode(resp,'GB2312','ignore').encode('utf-8','ignore')
            s = BeautifulSoup.BeautifulSoup(resp)
            tpc = s.find('div', {'class': 'tpc_content'})
            
            map(lambda i: self.massage_img(i), tpc.findAll('img'))
            return tpc.prettify()
        except Exception, e:
            elog({'url': url, 'err': str(e)}, 'RETRIEVE_PAGE_ERR')
            return ''

    def massage_img(self, img):
        """
        
        Arguments:
        - `self`:
        - `img`:
        """
        img.attrs[1:] = []

        url = img.attrs[0][1]

        # download it to local
        new_path = datetime.datetime.now().strftime('%Y/%m/%d')
        
        new_name =  "%s.%s" % (hp.md5sum(url), url[-3:])
        succ, new_url = hp.save_loc(url, '%s/%s' % (new_path, new_name))
        
        img.attrs[0] = (img.attrs[0][0], new_url)
        return succ, new_url


    def go(self):
        """
        
        Arguments:
        - `self`:
        """
        rsts = filter(lambda (title, link): any([wd in title
                                                 for wd in cfg.site_cl['wd_list']]) and hp.filter_history(link),
                      self.get_targets())

        # just write them all to the same blog
        host, u, p = cfg.site_cl['wp_cfg']
        map(lambda (title, content): hp.post_to_wp(host, u, p, title, content),
            [(title, self.get_page(link)) for title, link in rsts])
        
