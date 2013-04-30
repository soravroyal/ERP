CLASSPATH=.;jtds-1.2.5.jar

extract: compile
	del *.rdf *.zip /f
	java -cp $(CLASSPATH) GenerateRDF -olookuptables.rdf annexIActivity areaGroup confidentiality coordinateSystem country medium methodBasis methodType nACEActivity nUTSRegion pollutant riverBasinDistrict status unit wasteTreatment wasteType
	java -cp $(CLASSPATH) GenerateRDF -oFacility.rdf facility
	java -cp $(CLASSPATH) GenerateRDF -oActivity.rdf activity
	java -cp $(CLASSPATH) GenerateRDF -oCompetentAuthority.rdf competentAuthority
	java -cp $(CLASSPATH) GenerateRDF -oFacilityID_Changes.rdf facilityID_Changes
	java -cp $(CLASSPATH) GenerateRDF -oFacilityReport.rdf facilityReport
	java -cp $(CLASSPATH) GenerateRDF -oPollutantRelease.rdf pollutantRelease
	java -cp $(CLASSPATH) GenerateRDF -oPollutantReleaseMethodUsed.rdf pollutantReleaseMethodUsed
	java -cp $(CLASSPATH) GenerateRDF -oPollutantTransfer.rdf pollutantTransfer
	java -cp $(CLASSPATH) GenerateRDF -oPollutantTransferMethodUsed.rdf pollutantTransferMethodUsed
	java -cp $(CLASSPATH) GenerateRDF -oUploadedReports.rdf uploadedReports
	java -cp $(CLASSPATH) GenerateRDF -oWasteTransfer.rdf wasteTransfer
	java -cp $(CLASSPATH) GenerateRDF -oWasteTransferMethodUsed.rdf wasteTransferMethodUsed
	zip -r rdf_export . -i \*.rdf
	del *.rdf /f

compile: GenerateRDF.class

GenerateRDF.class: GenerateRDF.java
	javac -cp $(CLASSPATH) GenerateRDF.java -d .



