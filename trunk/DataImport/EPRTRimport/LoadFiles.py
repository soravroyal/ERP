'''
Created on 08/03/2013

@author: hjel8694
'''
import urllib2
import sys
import base64
#from urlparse import urlparse
from xml.etree.ElementTree import parse

from config import Config
import os
import StringIO
import csv
import datetime
from lxml import etree
import traceback
import operator


class eobj():
    env_releasedate = None
    env_reporteddate = None
    env_year = None
    env_country = None
    env_countrycode = None
    env_url = None
    env_path = None
    env_name = None
    env_filename = None
    env_title = None
    env_descr = None
    
    def __init__(self):
        return

class country():
    def __init__(self):
        self.n = None
        self.c = None
        return
    
class EPRTRimport():
    
    def __init__(self):
        self.conf = Config()
        self.envColl = []
        self.countries = {}

        return

    def copyXML(self,path, name):
        _url = None
        req = urllib2.Request(path)
        base64string = base64.encodestring(
                        '%s:%s' % (self.conf.cdr_user, self.conf.cdr_pass))[:-1]
        authheader =  "Basic %s" % base64string
        req.add_header("Authorization", authheader)
        try:
            _url = urllib2.urlopen(req)
        except IOError, e:
            # here we shouldn't fail if the username/password is right
            print "It looks like the username or password is wrong."
            sys.exit(1)
        _outp = os.path.join(self.conf.path,name)
        output = open( _outp,'wb')
        output.write(_url.read())
        output.close()
#        del _url

    def readEnvelope(self, path):
#        http://cdr.eionet.europa.eu/pl/eu/eprtrdat/envutc3xg/xml
        _envPath = os.path.dirname(path) +'/xml'
        req = urllib2.Request(_envPath)
        base64string = base64.encodestring(
                        '%s:%s' % (self.conf.cdr_user, self.conf.cdr_pass))[:-1]
        authheader =  "Basic %s" % base64string
        req.add_header("Authorization", authheader)
        try:
            _url = urllib2.urlopen(req)
        except IOError, e:
            # here we shouldn't fail if the username/password is right
            print "It looks like the username or password is wrong."
            sys.exit(1)

        try:
            tree = parse(StringIO.StringIO(_url.read()))
            elem = tree.getroot()
    
            _eo = eobj()
    
            for child in elem:
                if "date" in child.tag:
                    _eo.env_releasedate = child.text
                elif "title" in child.tag:
                    _eo.env_title = child.text
                elif "description" in child.tag:
                    ascii_def = child.text
                    uni_def = unicode(ascii_def)
                    _eo.env_descr = uni_def.encode('utf-8').replace(";",",")
                elif "countrycode" in child.tag:
                    _eo.env_countrycode = child.text
                elif "link" in child.tag:
                    _eo.env_url = child.text
                elif child.tag == "year":
                    _eo.env_year = child.text
    #                    _meth.mh_def = child.text
                elif "file" in child.tag:
#<file name="E-PRTR_data_PL_2010_-_v3.xml" type="text/xml" 
#schema="http://www.eionet.europa.eu/schemas/eprtr/PollutantReleaseAndTransferReport_2p0.xsd" 
#title="E-PRTR data PL 2010 - v3" restricted="no" 
#link="http://cdr.eionet.europa.eu/pl/eu/eprtrdat/envutc3xg/E-PRTR_data_PL_2010_-_v3.xml" 
#uploaded="2013-03-01T14:13:15Z"/>
                    if child.attrib['type'] == "text/xml":
                        _eo.env_reporteddate = child.attrib['uploaded']
                        _eo.env_path = child.attrib['link'] 
                        _eo.env_name = child.attrib['name'] 
            
            self.envColl.append(_eo) 
            return 1
#            del _url
        except:
            errmsg = 'Error - \n',elem.tag
            print errmsg
            return 0

    def go(self):
        for _u in self.conf.impUrls:
            _b = self.readEnvelope(_u)
        
        print 'loaded %s envelopes' % len(self.envColl)
#        def key1( a ): return a.attribute1
#        def key2( a ): return a.attribute2
        if len(self.envColl)>0:
            self.envColl.sort(key=operator.attrgetter('env_year'), reverse=False)
            self.envColl.sort(key=operator.attrgetter('env_countrycode'), reverse=False)

            self.ParseCountries()
            print 'Loaded %s county names from %s'% (len(self.countries), self.conf.countrypath)

            try:            
                _dir = os.path.join(self.conf.path,'00_config.csv')
                with open(_dir, 'wb') as f:  
                    writer = csv.writer(f, delimiter=';',quoting=csv.QUOTE_NONE, escapechar = '\\')
        #            writer.writerows(someiterable)        #spamWriter.writerow(['Spam', 'Lovely Spam', 'Wonderful Spam'])    
                    writer.writerow(['year','country code','Country','CDR url','Released','Reported','Description','Envelope','Files','Remark']) 
                    for _eo in self.envColl:
                        _name = '%s_EPRTR-%s.xml' % (_eo.env_countrycode,_eo.env_year)
                        self.copyXML(_eo.env_path, _name)
                        _l = []
                        _l.append(_eo.env_year)
                        _l.append(_eo.env_countrycode)
                        _l.append(self.countries[_eo.env_countrycode])
                        _l.append(_eo.env_url)
                        _l.append(str(_eo.env_releasedate).replace('Z',''))
                        _l.append(str(_eo.env_releasedate).replace('Z',''))
                        _l.append(_eo.env_descr)
                        _l.append(_eo.env_title)
                        _l.append(_eo.env_name)
                        _l.append('')
                        writer.writerow(_l) 
                        print 'Added %s to csv' % _eo.env_name
            
            except:
                messages = "Unexpected error in parsing the XML: %s" % sys.exc_info()[0]
                tb = sys.exc_info()[2]
                tbinfo = traceback.format_tb(tb)[0]
                messages += "PYTHON ERRORS:\nTraceback info:\n" + tbinfo + "\nError Info:\n" + str(sys.exc_info()[1])
                print messages
        print ' '
        print 'Done!'
#        _outp = os.path.join(self.conf.path,name)
#        output = open( _outp,'wb')
#        output.write(_url.read())
#        output.close()


#year;country code;Country;CDR url;Released;Reported;Description;Envelope;Files;Remark

#<envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" released="true" xsi:noNamespaceSchemaLocation="http://cdr.eionet.europa.eu/schemas/envelope-metadata.xsd">
#<title>E-PRTR data PL 2010 - v3</title>
#<description>Redelivery</description>
#<date>2013-03-01T15:13:37Z</date>
#<coverage>http://rod.eionet.europa.eu/spatial/29</coverage>
#<countrycode>PL</countrycode>
#<obligation>http://rod.eionet.europa.eu/obligations/538</obligation>
#<link>
#http://cdr.eionet.europa.eu/pl/eu/eprtrdat/envutc3xg
#</link>
#<year>2010</year>
#<endyear/>
#<partofyear>Whole Year</partofyear>
#<file name="E-PRTR_data_PL_2010_-_v3.xml" type="text/xml" schema="http://www.eionet.europa.eu/schemas/eprtr/PollutantReleaseAndTransferReport_2p0.xsd" title="E-PRTR data PL 2010 - v3" restricted="no" link="http://cdr.eionet.europa.eu/pl/eu/eprtrdat/envutc3xg/E-PRTR_data_PL_2010_-_v3.xml" uploaded="2013-03-01T14:13:15Z"/>
#<file name="Template_E_PRTR_resubmission_2010.xlsx" type="application/vnd.openxmlformats-officedocument.spreadsheetml.sheet" schema="" title="Template E-PRTR resubmission 2010" restricted="no" link="http://cdr.eionet.europa.eu/pl/eu/eprtrdat/envutc3xg/Template_E_PRTR_resubmission_2010.xlsx" uploaded="2013-03-01T14:13:30Z"/>
#</envelope>
    def ParseCountries(self):
        try:
            _doc = None
            if 'http' in self.conf.countrypath:
                _url = urllib2.urlopen(self.conf.countrypath).read()
                _doc= StringIO.StringIO(_url)
            else:
                _doc = self.conf.countrypath 

            self.countries = {}
            _tag = '{%s}Concept' % self.conf.ns['skos']
            context = etree.iterparse(_doc, events=('end',), tag=_tag)
            self._fast_iter(context, lambda elem: self._write_if_node(self._serialize(elem)))
        except:
            messages = "Unexpected error in parsing the XML: %s" % sys.exc_info()[0]
            tb = sys.exc_info()[2]
            tbinfo = traceback.format_tb(tb)[0]
            messages += "PYTHON ERRORS:\nTraceback info:\n" + tbinfo + "\nError Info:\n" + str(sys.exc_info()[1])
            print messages

    def _fast_iter(self, context, func):
        for event, elem in context:
            func(elem)
            elem.clear()
            while elem.getprevious() is not None:
                del elem.getparent()[0]
        del context
    
    def _write_if_node(self, country):
        if country is not None:
            self.countries[country.c] = country.n
    
    def _serialize(self, elem):
        _co = country()
        try:
            #Need base:
            for child in elem:
                if "notation" in child.tag:
                    #<skos:notation>2</skos:notation>
                    _co.c = child.text
                elif "prefLabel" in child.tag:
                    #<skos:prefLabel>Valid, but below detection limit measurement value given</skos:prefLabel>
                    ascii_def = child.text
                    uni_def = unicode(ascii_def)
                    _co.n = uni_def.encode('utf-8').replace(";",",")
            return _co
        except:
            errmsg = 'Error - \n',elem.tag
            print errmsg
            return None

    def getDate(self,inp):
        _obsDate = None
        if len(inp)>26: 
            inp = inp[:26]
        if int(inp[11:13]) == 24:
            #Changes to day after 2012-08-05T24:00:00 => 2012-08-06T00:00:00
            _newdate = datetime.datetime(int(inp[0:4]),int(inp[5:7]),int(inp[8:10]),0,int(inp[14:16]),int(inp[17:19]))
            return _newdate + datetime.timedelta(1)# + datetime.timedelta(milliseconds=-3)  
        else:
            format_str = "%Y-%m-%dT%H:%M:%S"
            try:
                return datetime.datetime.strptime(inp, format_str)
            except ValueError: 
                format_str = "%Y-%m-%dT%H:%M:%Sz"
                try:
                    return datetime.datetime.strptime(inp, format_str)
                except ValueError: 
                    try:
                        format_str = format_str[:19]
                        return datetime.datetime.strptime(inp, format_str)
                    except ValueError: 
                        try:
                            format_str = "%Y-%m-%d %H:%M:%S"
                            return datetime.datetime.strptime(inp, format_str)
                        except ValueError: 
                            try:
                                format_str = "%Y-%m-%d %H:%M:%S.%f"
                                return datetime.datetime.strptime(inp, format_str)
                            except ValueError: 
                                try:
                                    format_str = "%d-%m-%Y %H:%M:%S"
                                    return datetime.datetime.strptime(inp, format_str)
                                except ValueError:  
                                    return None



if __name__ == '__main__':
    ei = EPRTRimport()
    ei.go()
#    ei.copyXML('http://cdr.eionet.europa.eu/at/eu/eprtrdat/envutcobw/EU_Report_2010_28Feb2013.xml', 'AT_EPRTR-2010.xml')
#    ei.readEnvelope('http://cdr.eionet.europa.eu/at/eu/eprtrdat/envutcobw/EU_Report_2010_28Feb2013.xml')
#    ei.impTest('http://cdr.eionet.europa.eu/at/eu/eprtrdat/envutcobw/EU_Report_2010_28Feb2013.xml')
    