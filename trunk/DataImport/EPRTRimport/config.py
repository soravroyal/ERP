import os

#===============================================================================
# This configuration file is important for downloading EPRTR submissions
# It works together with Loadsubmissions.py
#===============================================================================

class Config():

    def __init__(self):
        #=======================================================================
        # IMPORTENT VALIDATE?
        # Set to True if the import has to create validations logs 
        #=======================================================================
        self.validate = True
        #=======================================================================
        # Importent - Date filter  
        # minReportingDate - only Submissions reported after this date (yyyy-mm-dd)
        # maxReportingDate - only Submissions reported before this date (yyyy-mm-dd)
        # If None filter will be ignored 
        #=======================================================================
        self.minReportingDate = '2013-01-01'
        self.maxReportingDate = None
        #=======================================================================
        # IMPORTENT  - CDR path and credentials
        #=======================================================================
        self.cdrserver = "http://cdr.eionet.europa.eu/" #CDR path
        self.obligation = "http://rod.eionet.europa.eu/obligations/538" # E-PRTR obligation url
        self.released = 1 #We only want released
        self.cdr_path = 'http://cdr.eionet.europa.eu/loggedin' #Used when accessing the restricted cdr envelopes 
        self.cdr_user = 'hjelmmor' #CDR eionet username
        self.cdr_pass = 'technical85' #CDR eionet password
        
        #=======================================================================
        # SQL Connection params
        # Server name and credentials for creating EPRTRxml and accessing the EPRTRmaster db
        #=======================================================================
        self.sp = {}
        self.sp['server'] = "sdkcga6332"
        self.sp['user'] = "gis"
        self.sp['passw'] = "tmggis"
        
        #=======================================================================
        # Submission filepaths 
        #=======================================================================
        self.path = 'D:\Projects\EEA\EPRTR\DataImport\XML_Import\Submission_2013_04' #Where xml and log files are stored

        #===============================================================================
        #
        # ! FROM here you don't have to change !
        #
        #===============================================================================

        #=======================================================================
        #
        # Paths that are not corrected
        #=======================================================================
#         self.subpath = os.path.join(self.path,'submissionlinks.csv') #Not used
        self.curr = os.path.dirname(__file__) #Current path
        self.batpath = os.path.join(self.curr,'Validate_and_Import_XML_File.bat') #Path to the bat file used for validation
        self.sqlpath = os.path.join(self.curr,'SQLScripts') # Folder in which to find all the sql files
#         self.mapfpath = os.path.join(self.curr,'MAPFORCE','EPRTR_Import_CMD.exe') # path to EPRTR_Import_CMD.exe
        #=======================================================================
        # USED namespaces
        # Used when accessing the envelope
        #=======================================================================
        self.ns = {}#NameSpace
        self.ns['rdf'] = 'http://www.w3.org/1999/02/22-rdf-syntax-ns#'
        self.ns['rdfs'] = 'http://www.w3.org/2000/01/rdf-schema#'
        self.ns['air'] = 'http://rdfdata.eionet.europa.eu/airbase/schema/'
        self.ns['skos'] = 'http://www.w3.org/2004/02/skos/core#'

        #===============================================================================
        # XMLDB
        # SQL scripts used for resetting the EPRTRxml database
        #===============================================================================
        self.xmldb = {}
        self.xmldb['name'] = 'EPRTRxml'
        _sqlfiles = []
        _sqlfiles.append('CreateTables_EPRTRxml.sql')
        _sqlfiles.append('CreateReferences_EPRTRxml.sql')
        _sqlfiles.append('Add_aux_cols_4_xmlimport.sql')
        _sqlfiles.append('SP_FindPreviousReferences.sql')
        _sqlfiles.append('copyXMLdata2EPRTR.sql')
        _sqlfiles.append('EPRTRXML_validate_procedure.sql')
        self.xmldb['files'] = _sqlfiles
        self.xmldb['reset_cols'] = 'reset_cols_4_xmlimport.sql'        


        return
        
