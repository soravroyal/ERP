import os



class Config():

    def __init__(self):
        #=======================================================================
        # Submission filepaths
        #=======================================================================
        self.path = 'D:\Projects\EEA\EPRTR\DataImport\XML_Import\Submission_2013_04'
        self.subpath = os.path.join(self.path,'submissionlinks.csv')
        #=======================================================================
        # Sql filepaths
        #=======================================================================
        self.basepath = 'D:\Projects\EEA\EPRTR\DataImport'
        self.sqlpath = os.path.join(self.basepath,'SQLScripts')
        #=======================================================================
        # CDR path and credentials
        #=======================================================================
        self.cdr_path = 'http://cdr.eionet.europa.eu/loggedin'
        self.cdr_user = 'hjelmmor'
        self.cdr_pass = 'technical85'
        #=======================================================================
        # URL to LOV country table - used for validation
        #=======================================================================
        self.countrypath = 'http://dd.eionet.europa.eu/vocabulary/common/countries/rdf'
        #=======================================================================
        # USED namespaces
        #=======================================================================
        self.ns = {}#NameSpace
        self.ns['rdf'] = 'http://www.w3.org/1999/02/22-rdf-syntax-ns#'
        self.ns['rdfs'] = 'http://www.w3.org/2000/01/rdf-schema#'
        self.ns['air'] = 'http://rdfdata.eionet.europa.eu/airbase/schema/'
        self.ns['skos'] = 'http://www.w3.org/2004/02/skos/core#'

#===============================================================================
        # Paths
        #===============================================================================
        
        return
        


#Paths
#http://cdr.eionet.europa.eu/pl/eu/eprtrdat/envutc3xg
#http://cdr.eionet.europa.eu/pl/eu/eprtrdat/envutc3xg/xml

#Name convention 
# 
