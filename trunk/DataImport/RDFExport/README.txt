
The RDF export uses a Java product that was developed for other projects.

There will occasionally be updates to the Java product. When this happens,
then the rdf-exporter-1.0-SNAPSHOT.jar will have to be recompiled.

The RDFExport directory links to an external SVN repository as a symbolic link.
To recompile the rdf-exported do:

    cd RDFExport
    mvn -Dmaven.test.skip=true install
    target/rdf-exporter-1.0-SNAPSHOT.jar ..
    cd ..
    svn ci rdf-exporter-1.0-SNAPSHOT.jar

RDFExport is a Maven project, and the website is here: http://maven.apache.org/

-------------------------------------------------------------------------------

Prerequisites for running RDFExport:
* Install JDK 1.7, make sure %JAVA_HOME% is pointing to it.
* Install gnuwin from http://gnuwin32.sourceforge.net/.  (GetGnuWin32-0.6.3.exe)

To generate RDF files we have to launch the process through RunRDF.bat or 
RunRDF_All_RDF.bat files. These two files are correct examples.
These files show you which RDF files will be generated. 

The process generates a RDFfiles.gz file. The compressed RDF files are placed 
within this file.

Note that the rdfexport.properties file must be configured 
with the correct parameters:	
		
	db.driver=net.sourceforge.jtds.jdbc.Driver
	db.database=jdbc:jtds:sqlserver://SERVER_NAME/EPRTRmaster
	db.user=USER_DB
	db.password=PSS_DB
	



