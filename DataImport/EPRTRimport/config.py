


class Config():
    #===============================================================================
    # import URL's
    #===============================================================================
    impUrls = []
    impUrls.append('http://cdr.eionet.europa.eu/pl/eu/eprtrdat/envutc3xg/E-PRTR_data_PL_2010_-_v3.xml')
    impUrls.append('http://cdr.eionet.europa.eu/pl/eu/eprtrdat/envutc2nw/E-PRTR_data_PL_2009_-_v6.xml')
    impUrls.append('http://cdr.eionet.europa.eu/pl/eu/eprtrdat/envutc1vw/E-PRTR_data_PL_2008_-_v7.xml')
    impUrls.append('http://cdr.eionet.europa.eu/pl/eu/eprtrdat/envutc0pg/E-PRTR_data_PL_2007_-v9.xml')
    
    impUrls.append('http://cdr.eionet.europa.eu/at/eu/eprtrdat/envutcobw/EU_Report_2010_28Feb2013.xml')
    impUrls.append('http://cdr.eionet.europa.eu/at/eu/eprtrdat/envutcjwg/EU_Report_2009_28Feb2013.xml')
    impUrls.append('http://cdr.eionet.europa.eu/at/eu/eprtrdat/envutcgpa/EU_Report_2008_28Feb2013.xml')
    impUrls.append('http://cdr.eionet.europa.eu/at/eu/eprtrdat/envutcxa/EU_Report_2007_28Feb2013.xml')
    
    impUrls.append('http://cdr.eionet.europa.eu/dk/eu/eprtrdat/envutcnew/FINAL_2010_E_PRTR.xml')
    
    impUrls.append('http://cdr.eionet.europa.eu/es/eu/eprtrdat/envutbqpa/1_2010_27022013_131058_1.xml')
    impUrls.append('http://cdr.eionet.europa.eu/es/eu/eprtrdat/envus89ra/1_2009_27022013_143453.xml')
    impUrls.append('http://cdr.eionet.europa.eu/es/eu/eprtrdat/envus4u7w/1_2008_27022013_104826.xml')
    impUrls.append('http://cdr.eionet.europa.eu/es/eu/eprtrdat/envuszuog/1_2007_26022013_95744.xml')
    
    impUrls.append('http://cdr.eionet.europa.eu/fr/eu/eprtrdat/envus_aog/E-PRTR_D2010_FR_20130219_134216.xml')
    impUrls.append('http://cdr.eionet.europa.eu/fr/eu/eprtrdat/envus_zew/E-PRTR_D2009_FR_20130219_155741.xml')
    impUrls.append('http://cdr.eionet.europa.eu/fr/eu/eprtrdat/envus_xrq/E-PRTR_D2008_FR_20130220_071328.xml')
    
    impUrls.append('http://cdr.eionet.europa.eu/be/eu/eprtrdat/envus_cca/BE_EPRTR2010HerzFebr2013.xml')
    impUrls.append('http://cdr.eionet.europa.eu/be/eu/eprtrdat/envus_b_w/BE_EPRTR2009HerzBebr2013.xml')
    impUrls.append('http://cdr.eionet.europa.eu/be/eu/eprtrdat/envus_b8q/BE_EPRTR2008HerzFebr2013.xml')
    impUrls.append('http://cdr.eionet.europa.eu/be/eu/eprtrdat/envus_adw/BE_EPRTR2007HerzFebr2013.xml')
    
    impUrls.append('http://cdr.eionet.europa.eu/pt/eu/eprtrdat/envus961q/PRTR2010_Fev2013_resubmission.xml')
    
    impUrls.append('http://cdr.eionet.europa.eu/cz/eu/eprtrdat/envus9qew/CZ_E-PRTR_2010_v4_28022013.xml')
    
    impUrls.append('http://cdr.eionet.europa.eu/ch/eu/eprtr/envuscoja/EUA-Export_2010_130222.xml')
    
    impUrls.append('http://cdr.eionet.europa.eu/de/eu/eprtrdat/envussllq/XML3_DE_Korr2_2010.xml')
    impUrls.append('http://cdr.eionet.europa.eu/de/eu/eprtrdat/envusc1ua/XML3_DE_Korr7_2007.xml')
    impUrls.append('http://cdr.eionet.europa.eu/de/eu/eprtrdat/envuscptw/XML3_DE_Korr7_2008.xml')
    impUrls.append('http://cdr.eionet.europa.eu/de/eu/eprtrdat/envuszyfq/XML3_DE_Korr4_2009.xml')

    impUrls.append('http://cdr.eionet.europa.eu/gb/eu/eprtrdat/envuth3qg/ALLDATA_2010_output_2.xml')


    def __init__(self):
        self.path = 'E:\Projects\EPRTR\DataImport\XML_Import\Resubmission_2013_02_28'
        self.cdr_path = 'http://cdr.eionet.europa.eu/loggedin'
        self.cdr_user = 'hjelmmor'
        self.cdr_pass = 'technical85'

        self.countrypath = 'http://dd.eionet.europa.eu/vocabulary/common/countries/rdf'
        
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
