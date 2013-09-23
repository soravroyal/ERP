@echo off
echo Starting RDF files generation

rmdir /s /q RDFfiles

mkdir RDFfiles

echo generating lookuptables.rdf...
REM java -cp  ./target/rdf-exporter-1.0-SNAPSHOT.jar;./target/jtds-1.2.5.jar eionet.rdfexport.Execute AnnexIActivity AreaGroup Confidentiality Country medium pollutant pollutantthreshold wastethreshold wastetype unit method methodtype rbd -f ./target/rdfexport.properties -o ./RDFfiles/lookuptables.rdf
java -cp  ./target/rdf-exporter-1.0-SNAPSHOT.jar;./target/jtds-1.2.5.jar eionet.rdfexport.Execute annexIActivity areaGroup confidentiality coordinateSystem country medium methodBasis methodType nACEActivity nUTSRegion pollutant riverBasinDistrict status unit wasteTreatment wasteType pollutantthreshold wastethreshold unit method methodtype rbd  -f ./target/rdfexport.properties -o ./RDFfiles/lookuptables.rdf 

echo generating facility.rdf...
java -cp  ./target/rdf-exporter-1.0-SNAPSHOT.jar;./target/jtds-1.2.5.jar eionet.rdfexport.Execute facility -f ./target/rdfexport.properties -o ./RDFfiles/Facility.rdf

echo Compressing files...

tar -cf RDFfiles.gz RDFfiles/

rmdir /s /q RDFfiles

echo Process finished.
	
pause