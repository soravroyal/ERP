RDFExport
==================================================
Created 2012-07-12 by Kostas Rutkauskas.

The RDFExport utility exports the EPRTR database to RDF format. The utility uses GenerateRDF from https://svn.eionet.europa.eu/repositories/Reportnet/RDFExport/E-PRTR. GenerateRDF requires 3 configuration files: database.properties, rdfexport.properties, and a makefile to run it. The property files and makefile are generated given database parameters by MakeConfiguration solution. The workflow of RDFExport is following:
* Build MakeConfiguration using msbuild
* Launch MakeConfiguration and generate property files
* Launch generated makefile, which compiles GenerateRDF and runs the export
* Cleanup and copy rdf_export.zip to .

Prerequisites for running RDFExport:
* Ensure msbuild directory is correct in RDFExport.bat
* Install gnuwin from http://gnuwin32.sourceforge.net/.
