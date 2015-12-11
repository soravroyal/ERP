Prerequisites for running RDFExport:
* Install JDK 1.7, make sure %JAVA_HOME% is pointing to it.

To generate RDF files we have to launch the process through RunRDF_All_RDF.sh or 
RunRDF_All_RDF.bat files.

The process generates a RDFfiles folder. The compressed RDF files are placed 
within this folder.

Note that the database.properties file must be configured 
with the correct parameters:	
		
	db.driver=net.sourceforge.jtds.jdbc.Driver
	db.database=jdbc:jtds:sqlserver://SERVER_NAME/EPRTRmaster
	db.user=USER_DB
	db.password=PSS_DB
	
You can copy database.properties-dist to database.properties and edit.

After generation you upload the RDF files to the website so they are available
from http://prtr.ec.europa.eu/rdf/. Compare the new sizes with the current ones
if there are significant differences, then check the scripts.

-------------------------------------------------------------------------------

The RDF export uses a Java product that was developed for other projects.

There will occasionally be updates to the Java product. When this happens,
then get a new version from Jenkins at
http://ci.eionet.europa.eu/view/Java/job/RDFExport/lastSuccessfulBuild/artifact/target/rdf-exporter-1.3-SNAPSHOT-jar-with-dependencies.jar


