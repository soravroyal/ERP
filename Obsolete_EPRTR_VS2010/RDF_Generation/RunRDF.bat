@echo off
echo Building the library - uncomment
rem cd RDFExport
rem mvn -Dmaven.test.skip=true install
rem cd ..
rem copy RDFExport\target\rdf-exporter-1.0-SNAPSHOT.jar .

echo Starting RDF files generation

rmdir /s /q RDFfiles

mkdir RDFfiles

echo generating lookuptables.rdf...
REM java -cp  rdf-exporter-1.0-SNAPSHOT.jar;./jtds-1.2.5.jar eionet.rdfexport.Execute AnnexIActivity AreaGroup Confidentiality Country medium pollutant pollutantthreshold wastethreshold wastetype unit method methodtype rbd -f rdfexport.properties -o ./RDFfiles/lookuptables.rdf
java -cp  rdf-exporter-1.0-SNAPSHOT.jar;./jtds-1.2.5.jar eionet.rdfexport.Execute annexIActivity areaGroup confidentiality coordinateSystem country medium methodBasis methodType nACEActivity nUTSRegion pollutant riverBasinDistrict status unit wasteTreatment wasteType pollutantthreshold wastethreshold unit method methodtype rbd  -f rdfexport.properties -o ./RDFfiles/lookuptables.rdf 

echo generating facility.rdf...
java -cp  rdf-exporter-1.0-SNAPSHOT.jar;./jtds-1.2.5.jar eionet.rdfexport.Execute facility -f rdfexport.properties -o ./RDFfiles/Facility.rdf

echo Compressing files... Why?

tar -cf RDFfiles.gz RDFfiles/

rmdir /s /q RDFfiles

echo Process finished.
	
pause
