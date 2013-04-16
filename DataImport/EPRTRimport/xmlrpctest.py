

#from SimpleXMLRPCServer import SimpleXMLRPCServer, SimpleXMLRPCRequestHandler

import xmlrpclib
from config import Config
import sys
import traceback
import operator

class cdrEnvelope(object):
    description = None
    startyear = None
    locality = None
    url = None
    country = None
    title = None
    partofyear = None
    endyear = None
    country_code = None
    country_name = None
    dataflow_uris = None
    feedbacks = None
    isreleased = None
#    ':[
#    ['feedback1365517838', 1, 'text/html', '<p>\n European E\n', None, '2013-04-09 16:30:38']
#  , ['AutomaticQA_87808_1365518161', 1, 'text/html;charset=UTF-8', '<div style="font-size:13px;">\n', 'EPRTR__Iceland_reporting_year_2011.XML', '2013-04-09 16:30:38']
#  , ['AutomaticQA_87809_1365518161', 1, 'text/html', 'Feedback too large for inline display; <a href="qa-output/view">see attachment</a>.', 'EPRTR__Iceland_reporting_year_2011.XML', '2013-04-09 16:30:38']
#  , ['AutomaticQA_87814_1365518162', 1, 'text/html;charset=UTF-8', '<div class="feedbacktext">/div>\n', 'EPRTR__Iceland_reporting_year_2011.XML', '2013-04-09 16:30:38'], 
#    ['AutomaticQA_87813_1365518162', 1, 'text/html;charset=UTF-8', u'<div style="font-size:13px;" .XML', '2013-04-09 16:30:38'], 
#    ['AutomaticQA_87812_1365518162', 1, 'text/html;charset=UTF-8', u'<div class="feedbacktext"\n', 'EPRTR__Iceland_reporting_year_2011.XML', '2013-04-09 16:30:38']
#]
#    , 'released': '2013-04-09T14:30:38Z'}
    
    
    
    
    
    def __init__(self):
        return    

class cdrtest():
    def __init__(self):
        self.conf = Config()
        self.envs = []

    def go(self):
#        server = xmlrpclib.ServerProxy("http://%s:%s@cdr.eionet.europa.eu/loggedin/" % (self.conf.cdr_user, self.conf.cdr_pass))
        cdrserver = "http://cdr.eionet.europa.eu/"
        obligation = "http://rod.eionet.europa.eu/obligations/538"
        released = 1
        try:
            server = xmlrpclib.ServerProxy(cdrserver)
#            for envelope in server.xmlrpc_search_envelopes_events(obligation, released):

#<dtml-in "ReportekEngine.getSearchResults(meta_type='Report Envelope',
#          country=REQUEST['country_uri'],
#          dataflow_uris=['http://rod.eionet.eu.int/obligations/538'],
#          reportingdate={'query': DateTime(REQUEST['mindate']), 'range': 'min'},
#          sort_on='reportingdate',
#          sort_order='descending')">
#            for envelope in server.xmlrpc_search_envelopes(obligation, released):

            for envelope in server.xmlrpc_search_envelopes_feedback(obligation, released):
                reportingdate = envelope['released']
                if reportingdate[:4] not in ('2013'):
                    continue
                if str(envelope['startyear']) not in ('2011'):
                    continue
                if str(envelope['country_code']) not in ('PT'):
                    continue
                _env = cdrEnvelope()
                _env.country = envelope['country']
                _env.country_code = envelope['country_code']
                _env.country_name = envelope['country_name']
                _env.dataflow_uris = envelope['dataflow_uris']
                _env.description = envelope['description']
                _env.endyear = envelope['endyear']
                _env.locality = envelope['locality']
                _env.partofyear = envelope['partofyear']
                _env.startyear = envelope['startyear']
                _env.title = envelope['title']
                _env.url = envelope['url']
#                _env.isreleased = envelope['isreleased']
                _env.feedbacks = envelope['feedbacks']
#                _env.events = envelope['events']
                self.envs.append(_env)
                
                
            get_attr = operator.attrgetter('country_code')
            _di = sorted(self.envs, key=get_attr)
            for _e in _di:
#                _f = _e.events
                _f = _e.feedbacks
                for _fe in _f:
                    print _fe# '%s * %s * %s * %s' % (_fe[0],_fe[1],_fe[2],_fe[5])
                print '%s * %s * %s * %s * %s * %s *-* %s' % (_e.country_code, _e.startyear, _e.endyear,_e.title, _e.isreleased, _e.description, _f[len(_f)-2])
             
            print '%s' % len(self.envs) 
               
        except xmlrpclib.ProtocolError as err:
            print "A protocol error occurred"
            print "URL: %s" % err.url
            print "HTTP/HTTPS headers: %s" % err.headers
            print "Error code: %d" % err.errcode
            print "Error message: %s" % err.errmsg
        except:
            messages = "Unexpected error in recreating the XML database: %s" % sys.exc_info()[0]
            tb = sys.exc_info()[2]
            tbinfo = traceback.format_tb(tb)[0]
            messages += "PYTHON ERRORS:\nTraceback info:\n" + tbinfo + "\nError Info:\n" + str(sys.exc_info()[1])
            print messages

#        prx = xmlrpclib.ServerProxy('http://cdr.eionet.europa.eu')
#        base64string = base64.encodestring('%s:%s' % (self.conf.cdr_user, self.conf.cdr_pass))[:-1]
#        authheader =  "Basic %s" % base64string
#        prx.add_header("Authorization", authheader)
##        token = prx.login(self.conf.cdr_user, self.conf.cdr_pass)
#        #print proxy.list_contents()
#        # Print list of available methods
#        
#        for method_name in prx.system.listMethods():
#            print '=' * 60
#            print method_name
#            print '-' * 60
#            print prx.system.methodHelp(method_name)
#            print
            
if __name__ == '__main__':
    ei = cdrtest()
    ei.go()