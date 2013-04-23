import _mssql
import sys
import traceback
import os
from config import Config
import subprocess
import xmlrpclib
import operator
import urllib2
import base64
from xml.etree.ElementTree import parse
import StringIO
import datetime
import csv

class cdrEnvelope(object):
    name = None
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
    released = None
    releasedate = None
    uploaded = None
    restricted = None
    xmlfilepath = None 
    xmlfilename = None 
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


class dbfunc():
    
    def __init__(self):
        self.conf = Config()
        self.envs = []
        return
    
    #===========================================================================
    # This function loads SQL files into memory and executres the SQL
    # Each row is loaded into a strin unless it starts with --
    # When the row contains GO or ; the SQL sting is executed and reset to ''
    # If the SQL creates a stored procedure the ; is ignored   
    #===========================================================================
    def readSqlFile(self, conn, sqlpath):
        try:
            _sp = False
            sqlQuery = ''
            with open(sqlpath, 'r') as inp:
                
                for line in inp:
                    if 'create procedure' in line: _sp = True
                    if line == 'GO\n':
                        conn.execute_non_query(sqlQuery)
                        sqlQuery = ''
                    elif str(line).lstrip().startswith('--'):
                        sqlQuery = sqlQuery
                    elif str(line).rstrip().endswith(';') and not _sp:
                        sqlQuery = sqlQuery + line
                        conn.execute_non_query(sqlQuery)
                        sqlQuery = ''
                    elif 'PRINT' in line:
                        disp = line.split("'")[1]
                        print(disp, '\r')
                    else:
                        sqlQuery = sqlQuery + line
              
                if str(sqlQuery).strip() != '':
                    conn.execute_non_query(sqlQuery)
                    sqlQuery = ''

            inp.close()
            return 1
        except _mssql.MssqlDatabaseException,e:
            messages = 'MssqlDatabaseException raised\n' 
            messages += 'File: %s' %  sqlpath
            messages += ' message: %s\n' % e.message 
            messages += ' number: %s\n' % e.number 
            messages += ' severity: %s\n' % e.severity 
            messages += ' state: %s\n' % e.state
            print messages
            return 0 
        except _mssql.MssqlDriverException ,e:
            messages = 'MssqlDriverException  raised\n' 
            messages += ' message: %s\n' % e.message 
            print messages
            return 0 
        except:
            tb = sys.exc_info()[2]
            tbinfo = traceback.format_tb(tb)[0]
            messages =  "PYTHON ERRORS:\nTraceback info:\n" + tbinfo + "\nError Info:\n" + str(sys.exc_info()[1])
    #            print pymsg
            print messages
            return 0
    
    #===========================================================================
    # This function recreates the Eprtrxml database 
    # This is done for each new xml import
    #===========================================================================
    def recreateXMLDB(self):
        try:
#             print 'Deletes existing EPRTRxml database!'
            conn = _mssql.connect(server=self.conf.sp['server'], user=self.conf.sp['user'], password=self.conf.sp['passw'], database='')
            _sql = "IF DB_ID('{0}') IS NOT NULL BEGIN ALTER DATABASE {0} SET SINGLE_USER WITH ROLLBACK IMMEDIATE; DROP DATABASE {0}; END;".format(self.conf.xmldb['name'])
            conn.execute_non_query(_sql)
            print 'Creates new EPRTRxml database!'
            conn.execute_non_query("CREATE DATABASE {0} COLLATE Latin1_General_CI_AS;".format(self.conf.xmldb['name']))
            conn.close()
            conn = _mssql.connect(server=self.conf.sp['server'], user=self.conf.sp['user'], password=self.conf.sp['passw'], database=self.conf.xmldb['name'])
            _lst = list(self.conf.xmldb['files'])
            for _fls in _lst:
                if not self.readSqlFile(conn, os.path.join(self.conf.sqlpath,_fls)): return 0
#                 print 'The sql file %s was executed successfully!' % _fls#
            #REM Create database structure:
            #SET SQLCMDDBNAME=EPRTRxml
            #sqlcmd -i %basedir%\CreateTables_EPRTRxml.sql
            #sqlcmd -i %basedir%\CreateReferences_EPRTRxml.sql
            #sqlcmd -i %basedir%\Add_aux_cols_4_xmlimport.sql
            #sqlcmd -i %basedir%\SP_FindPreviousReferences.sql
            #sqlcmd -i %basedir%\copyXMLdata2EPRTR.sql
            #sqlcmd -i %basedir%\EPRTRXML_validate_procedure.sql        
            print 'EPRTRxml database now recreated'
            return 1

        except _mssql.MssqlDatabaseException,e:
            messages = 'MssqlDatabaseException raised\n' 
            messages += ' message: %s\n' % e.message 
            messages += ' number: %s\n' % e.number 
            messages += ' severity: %s\n' % e.severity 
            messages += ' state: %s\n' % e.state
            print messages
            return 0 
        except _mssql.MssqlDriverException ,e:
            messages = 'MssqlDriverException  raised\n' 
            messages += ' message: %s\n' % e.message 
            print messages
            return 0 
        except:
            tb = sys.exc_info()[2]
            tbinfo = traceback.format_tb(tb)[0]
            messages =  "PYTHON ERRORS:\nTraceback info:\n" + tbinfo + "\nError Info:\n" + str(sys.exc_info()[1])
    #            print pymsg
            print messages
            return 0
        finally:
            conn.close()

#===============================================================================
# This function is called from batch instead to produce log output            
#===============================================================================
#     def importXMLintoXMLdb(self, xmlfile):
#         try:
# #            p = subprocess.call([self.conf.mapfpath, "%s %s %s %s" % (os.path.join(self.conf.path,xmlfile), self.conf.sp['server'], self.conf.sp['user'], self.conf.sp['passw'])], shell=True, stdout=subprocess.PIPE, stderr=subprocess.STDOUT)
#             p = subprocess.Popen("%s %s %s %s %s" % (self.conf.mapfpath,os.path.join(self.conf.path,xmlfile), self.conf.sp['server'], self.conf.sp['user'], self.conf.sp['passw']), shell=True, stdout=subprocess.PIPE, stderr=subprocess.STDOUT)
# #            p.stdin.write("dir\n")
# #            print p.communicate()[0]
# #            p.stdin.close()
#             for line in p.stdout.readlines():
#                 print line
#                 retval = p.wait()
# 
#             return 1
#         except:
#             tb = sys.exc_info()[2]
#             tbinfo = traceback.format_tb(tb)[0]
#             messages =  "PYTHON ERRORS:\nTraceback info:\n" + tbinfo + "\nError Info:\n" + str(sys.exc_info()[1])
#     #            print pymsg
#             print messages
#             return 0

    #===========================================================================
    # This function request the recent EPRTR website for submission to download 
    # In order to do so we use the xmlrpc library to request xmlrpc functions on cdr
    #===========================================================================
    def requestSubmissions(self):
        try:
            server = xmlrpclib.ServerProxy(self.conf.cdrserver)
            #xmlrpc_search_envelopes_feedback returns the cdr feedbacks
            #For more info https://github.com/eea/Products.Reportek/blob/master/extras/zodb_scripts/xmlrpc_search_envelopes_feedback.py
            for envelope in server.xmlrpc_search_envelopes_feedback(self.conf.obligation, self.conf.released):
                _b = False
                #Filter on begin date - submissions uploaded after this date - date set in config file
                if self.conf.minReportingDate is not None and self.getDate(str(envelope['released']).upper().replace('Z', '')) < self.getDate(self.conf.minReportingDate): 
                    continue
                #Filter on end date - submissions uploaded before this date - date set in config file
                if self.conf.maxReportingDate is not None and self.getDate(str(envelope['released']).upper().replace('Z', '')) > self.getDate(self.conf.maxReportingDate): 
                    continue
                # Ready for import is the feedback title that indicates that the xml file are ready for import
                if not 'ready for import' in str(envelope['feedbacks'][len(envelope['feedbacks'])-1]).lower(): 
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
                _env.released = envelope['released']
                _env.feedbacks = envelope['feedbacks']
#                _env.events = envelope['events']
                self.envs.append(_env)
            
            #We order the list by year and then by country        
            self.envs.sort(key=operator.attrgetter('startyear'), reverse=False)
            self.envs.sort(key=operator.attrgetter('country_code'), reverse=False)
# 
            for _e in self.envs:
#                     print _fe[len(_fe)-1]# '%s * %s * %s * %s' % (_fe[0],_fe[1],_fe[2],_fe[5])
                print '%s * %s * %s * %s * %s * %s' % (_e.country_code, _e.startyear, _e.endyear,_e.title, _e.url, _e.released)
            print 'Number of submissions: %s' % len(self.envs)
            return 1 
               
        except xmlrpclib.ProtocolError as err:
            print "A protocol error occurred"
            print "URL: %s" % err.url
            print "HTTP/HTTPS headers: %s" % err.headers
            print "Error code: %d" % err.errcode
            print "Error message: %s" % err.errmsg
            return 0
        except:
            messages = "Unexpected error in recreating the XML database: %s" % sys.exc_info()[0]
            tb = sys.exc_info()[2]
            tbinfo = traceback.format_tb(tb)[0]
            messages += "PYTHON ERRORS:\nTraceback info:\n" + tbinfo + "\nError Info:\n" + str(sys.exc_info()[1])
            print messages
            return 0

    #===========================================================================
    # This function reads the submission envelope to get further details
    # The function uses Urllib2 and base64 for encoding credentials
    #===========================================================================
    def readEnvelope(self, path, env):
#        http://cdr.eionet.europa.eu/pl/eu/eprtrdat/envutc3xg/xml
#        _envPath = os.path.dirname(path) +'/xml'
        req = urllib2.Request(path+'/xml')
#         base64string = base64.encodestring(
#                         '%s:%s' % (self.conf.cdr_user, self.conf.cdr_pass))[:-1]
#         authheader =  "Basic %s" % base64string
#         req.add_header("Authorization", authheader)
        try:
            _url = urllib2.urlopen(req)
        except IOError, e:
            # here we shouldn't fail if the username/password is right
            print "It looks like the username or password is wrong."
            sys.exit(1)
        try:
            tree = parse(StringIO.StringIO(_url.read()))
            elem = tree.getroot()
    
            for child in elem:
                if "date" in child.tag:
                    env.releasedate = str(child.text).replace('Z','')                
                if "file" in child.tag:
                    if child.get('type') == "text/xml":
                        env.xmlfilepath = child.get('link') 
                        env.xmlfilename = child.get('name')
                        env.restricted = True if (str(child.get('restricted')).lower() == 'yes') else False
                        if path == 'http://cdr.eionet.europa.eu/ie/eu/eprtrdat/envuwwvcg': 
                            print env.xmlfilename, ' - ',child.get('restricted'),' - ',str(env.restricted) 
                        env.uploaded = str(child.get('uploaded')).replace('Z','') 
                        break
 
            del child, elem, tree
            return 1
        except:
            messages = "Unexpected error in recreating the XML database: %s" % sys.exc_info()[0]
            tb = sys.exc_info()[2]
            tbinfo = traceback.format_tb(tb)[0]
            messages += "PYTHON ERRORS:\nTraceback info:\n" + tbinfo + "\nError Info:\n" + str(sys.exc_info()[1])
            print messages
            return 0

    #===========================================================================
    # This function renames and copies the uploaded XML file to the project path
    #===========================================================================
    def copyXML(self,path, name):
        try:
            _url = None
            _outp = os.path.join(self.conf.path,name)
            if os.path.exists(_outp): os.remove(_outp)
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
            output = open( _outp,'wb')
            output.write(_url.read())
            output.close()
            return 1
        except:
            messages = "Unexpected error in recreating the XML database: %s" % sys.exc_info()[0]
            tb = sys.exc_info()[2]
            tbinfo = traceback.format_tb(tb)[0]
            messages += "PYTHON ERRORS:\nTraceback info:\n" + tbinfo + "\nError Info:\n" + str(sys.exc_info()[1])
            print messages
            return 0

#     def copyXml2Master(self,env):
#         try:
#             conn = _mssql.connect(server=self.conf.sp['server'], user=self.conf.sp['user'], password=self.conf.sp['passw'], database=self.conf.xmldb['name'])
#             if not self.readSqlFile(conn, os.path.join(self.conf.sqlpath,self.conf.xmldb['reset_cols'])): return 0
#             print 'The sql file %s was executed successfully!' % self.conf.xmldb['reset_cols']
#             _sql = """DECLARE @res INT
#             EXEC @res = EPRTRxml.dbo.import_xml @pCDRURL=N'{0}',@pCDRUploaded=N'{1}', @pCDRReleased=N'{2}', @pResubmitReason='{3}';
#             SELECT @res
#             """.format(env.url, env.releasedate, env.releasedate, env.description)
#             
#             res = conn.execute_scalar(_sql) 
#             print 'Validation returned: %s' % res
# 
# #echo Copying data from xml to master
# #sqlcmd -i %sqlscript_dir%\reset_cols_4_xmlimport.sql
# #sqlcmd -Q "EXEC EPRTRxml.dbo.import_xml @pCDRURL=N'%cdrUrl%',@pCDRUploaded=N'%cdrUploaded%', @pCDRReleased=N'%cdrReleased%', @pResubmitReason='%cdrDescription%';"
# #echo -----------------------------------------------
#             return 1
#         except:
#             messages = "Unexpected error in recreating the XML database: %s" % sys.exc_info()[0]
#             tb = sys.exc_info()[2]
#             tbinfo = traceback.format_tb(tb)[0]
#             messages += "PYTHON ERRORS:\nTraceback info:\n" + tbinfo + "\nError Info:\n" + str(sys.exc_info()[1])
#             print messages
#             return 0


    #===========================================================================
    # This function calls the Validate_and_Import_XML_File.bat batch file 
    # It is called i a way so that the print statements from the stored procedure is loaded into the log file
    # to call an external program/ batch we use subprocess.Popen
    #===========================================================================
    def callexebat(self,name,env):
        try:
            _str = '"%s" > %s %s %s %s ' % (self.conf.batpath,os.path.join(self.conf.path,'logs',name + '.log'),self.conf.curr,self.conf.path,'true' if self.conf.validate else 'false')
#            Validate_and_Import_XML_File.bat > %data_dir%\logs\!filename!.log %basedir%  %data_dir%  %doValidate% 
            _str += '"%s" %s "%s" "%s" "%s" "%s"' % (env.title,name,env.url,env.uploaded if (env.uploaded is not None and env.uploaded is not '') else env.releasedate,env.releasedate,env.description)
#             "!title!"  !filename!  "!cdrUrl!"  "!cdrUploaded!"  "!cdrReleased!"  "!cdrDescription!"
            _str += ' %s %s %s' % (self.conf.sp['server'],self.conf.sp['user'], self.conf.sp['passw'])
#            p = subprocess.Popen([]_str, shell=True, stdout=subprocess.PIPE, stderr=subprocess.STDOUT)
            p = subprocess.Popen(_str, shell=True, stdout=subprocess.PIPE, stderr=subprocess.STDOUT)
#            print p.communicate()[0]
            for line in p.stdout.readlines():
                print line
                retval = p.wait()
#                call Validate_and_Import_XML_File.bat > %data_dir%\logs\!filename!.log %basedir%  %data_dir%  %doValidate%  "!title!"  !filename!  "!cdrUrl!"  "!cdrUploaded!"  "!cdrReleased!"  "!cdrDescription!"
            return 1
        except:
            messages = "Unexpected error in recreating the XML database: %s" % sys.exc_info()[0]
            tb = sys.exc_info()[2]
            tbinfo = traceback.format_tb(tb)[0]
            messages += "PYTHON ERRORS:\nTraceback info:\n" + tbinfo + "\nError Info:\n" + str(sys.exc_info()[1])
            print messages
            return 0

    #===========================================================================
    # This function writes a status csv file in the log folder summerizing which files that has been imported and some meta data 
    #===========================================================================
    def writecsv(self):
        try:
            _csv = os.path.join(self.conf.path,'logs','eprtrimport_%s.csv'% (datetime.datetime.now().strftime("%Y_%m_%d_%H%M")))
            with open(_csv, 'wb') as f:  
                writer = csv.writer(f, delimiter=';',quoting=csv.QUOTE_NONE, escapechar = '\\')
    #            writer.writerows(someiterable)        #spamWriter.writerow(['Spam', 'Lovely Spam', 'Wonderful Spam'])    
                writer.writerow(['#Year','Country code','Country','CDR url','Released','Uploaded','Description','Envelope','Files','Logfile','Restricted']) 
                _c = 0
                for _env in self.envs:
                    _l = []
                    _l.append(_env.startyear)
                    _l.append(_env.country_code)
                    _l.append(_env.country_name)
                    _l.append(_env.url)
                    _l.append(_env.releasedate)
                    _l.append(_env.uploaded)
                    _l.append(_env.description)
                    _l.append(_env.title)
                    _l.append(_env.xmlfilename)
                    _l.append(_env.name + '.log')
                    _l.append(_env.restricted)
                    writer.writerow(_l)
                    _c += 1 
                    if self.conf.limited is not None and _c >= self.conf.limited: break

            return 1
        except:
            messages = "Unexpected error in recreating the XML database: %s" % sys.exc_info()[0]
            tb = sys.exc_info()[2]
            tbinfo = traceback.format_tb(tb)[0]
            messages += "PYTHON ERRORS:\nTraceback info:\n" + tbinfo + "\nError Info:\n" + str(sys.exc_info()[1])
            print messages
            return 0

    #===========================================================================
    # This function is a reuse - a function to parse a date string into a datetime object 
    #===========================================================================
    def getDate(self,inp):
        _obsDate = None
        if len(inp)>26: 
            inp = inp[:26]
        if len(inp)>14 and int(inp[11:13]) == 24:
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
                                    try:
                                        format_str = "%Y-%m-%d"
                                        return datetime.datetime.strptime(inp, format_str)
                                    except ValueError:  
                                        return None

    #===========================================================================
    # Main function whic orchestras the workflow
    #===========================================================================
    def go(self):
        if not os.path.exists(os.path.join(self.conf.path,'logs')):
            os.makedirs(os.path.join(self.conf.path,'logs'))

        if not self.requestSubmissions():
            print 'Error in requesting E-PRTR submissions!'
            return 0
        _c = 0
        for _env in self.envs:
            _env.name = '%s_EPRTR-%s.xml' % (_env.country_code,_env.startyear)
            if not os.path.exists(os.path.join(self.conf.path,'logs',_env.name + '.log')):
                print '** - treats the %s %s %s' % (_env.country_code,_env.startyear,_env.url)
                if not self.readEnvelope(_env.url, _env):
                    print 'Error in reading the envelope!'
                    return 0
#                 if not self.copyXML(_env.xmlfilepath, _env.name):
#                     print 'Error in copying the xml to local folder!'
#                     return 0
#                 if not self.recreateXMLDB():
#                     print 'Error in resetting the EprtrXml database!'
#                     return 0
#                 if not self.callexebat(_env.name, _env):
#                     print 'Error in reading the envelope!'
#                     return 0
            _c += 1
            if self.conf.limited is not None and _c >= self.conf.limited: break
                
        if not self.writecsv():
            print 'Error in writing status csv file!'
            return 0
        print 'EPRTR files successfully imported!'
        
if __name__ == '__main__':
    ei = dbfunc()
    ei.go()
