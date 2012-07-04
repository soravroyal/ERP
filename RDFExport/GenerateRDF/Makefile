CLASSPATH=bin;bin/jtds-1.2.5.jar

extract: compile
	del *.rdf *.zip /f
	java -cp $(CLASSPATH) GenerateRDF  annexIActivity areaGroup confidentiality coordinateSystem country medium methodBasis methodType nACEActivity nUTSRegion pollutant riverBasinDistrict status unit wasteTreatment wasteType facility > lookuptables.rdf
	java -cp $(CLASSPATH) GenerateRDF activity > Activity.rdf
	java -cp $(CLASSPATH) GenerateRDF eper2EPRTR_AnnexIActivity > Eper2EPRTR_AnnexIActivity.rdf
	java -cp $(CLASSPATH) GenerateRDF eper2EPRTR_NACEActivity > Eper2EPRTR_NACEActivity.rdf
	java -cp $(CLASSPATH) GenerateRDF facilityID_Changes > FacilityID_Changes.rdf
	java -cp $(CLASSPATH) GenerateRDF facilityReport > FacilityReport.rdf
	java -cp $(CLASSPATH) GenerateRDF pollutantRelease > PollutantRelease.rdf
	java -cp $(CLASSPATH) GenerateRDF pollutantReleaseAndTransferReport > PollutantReleaseAndTransferReport.rdf
	java -cp $(CLASSPATH) GenerateRDF pollutantReleaseMethodUsed > PollutantReleaseMethodUsed.rdf
	java -cp $(CLASSPATH) GenerateRDF pollutantTransfer > PollutantTransfer.rdf
	java -cp $(CLASSPATH) GenerateRDF pollutantTransferMethodUsed > PollutantTransferMethodUsed.rdf
	java -cp $(CLASSPATH) GenerateRDF uploadedReports > UploadedReports.rdf
	java -cp $(CLASSPATH) GenerateRDF wasteTransfer > WasteTransfer.rdf
	java -cp $(CLASSPATH) GenerateRDF wasteTransferMethodUsed > WasteTransferMethodUsed.rdf
	zip -r rdf_export . -i \*.rdf
	del *.rdf /f

compile: GenerateRDF.class

GenerateRDF.class: GenerateRDF.java
	javac -cp $(CLASSPATH) GenerateRDF.java -d bin



