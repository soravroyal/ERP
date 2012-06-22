CLASSPATH=bin;bin/jtds-1.2.5.jar

extract: compile
	del *.rdf *.zip /f
	java -cp $(CLASSPATH) GenerateRDF  Annexiactivity Areagroup Confidentiality Coordinatesystem Country Countryareagroup Medium Methodbasis Methodtype Naceactivity Nutsregion Pollutant Pollutantthreshold Riverbasindistrict Status Unit Wastethreshold Wastetreatment Wastetype >lookuptables.rdf
	java -cp $(CLASSPATH) GenerateRDF  activity > Activity.rdf
	java -cp $(CLASSPATH) GenerateRDF  Eper2eprtr_annexiactivity > Eper2eprtr_annexiactivity.rdf
	java -cp $(CLASSPATH) GenerateRDF  Eper2eprtr_naceactivity > Eper2eprtr_naceactivity.rdf
	java -cp $(CLASSPATH) GenerateRDF  Facilityid_changes > Facilityid_changes.rdf
	java -cp $(CLASSPATH) GenerateRDF  Facilityreport > Facilityreport.rdf
	java -cp $(CLASSPATH) GenerateRDF  Pollutantrelease > Pollutantrelease.rdf
	java -cp $(CLASSPATH) GenerateRDF  Pollutantreleaseandtransferreport > Pollutantreleaseandtransferreport.rdf
	java -cp $(CLASSPATH) GenerateRDF  Pollutantreleasemethodused > Pollutantreleasemethodused.rdf
	java -cp $(CLASSPATH) GenerateRDF  Pollutanttransfer > Pollutanttransfer.rdf 
	java -cp $(CLASSPATH) GenerateRDF  Pollutanttransfermethodused > Pollutanttransfermethodused.rdf
	java -cp $(CLASSPATH) GenerateRDF  Uploadedreports > Uploadedreports.rdf
	java -cp $(CLASSPATH) GenerateRDF  Wastetransfer > Wastetransfer.rdf
	java -cp $(CLASSPATH) GenerateRDF  Wastetransfermethodused > Wastetransfermethodused.rdf
	zip -r rdf_export . -i \*.rdf
	del *.rdf /f

compile: GenerateRDF.class

GenerateRDF.class: GenerateRDF.java
	javac -cp $(CLASSPATH) GenerateRDF.java -d bin


